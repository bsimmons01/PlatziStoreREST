//
//  HTTPClient.swift
//  Platzi
//
//  Created by Brian Simmons on 10/7/25.
//

import Foundation

// MARK: - HTTPMethod
// Enum representing supported HTTP methods and their associated data (query items or body).
enum HTTPMethod {
  case get([URLQueryItem])   // GET request with optional query parameters
  case post(Data?)           // POST request with optional HTTP body
  case delete                // DELETE request (no body)
  case put(Data?)            // PUT request with optional HTTP body

  // Computed property to return the string name of each HTTP method
  var name: String {
    switch self {
    case .get:
      return "GET"
    case .post:
      return "POST"
    case .delete:
      return "DELETE"
    case .put:
      return "PUT"
    }
  }
}

// MARK: - Resource
// A generic structure that represents a network resource.
// T is a Codable type that will be decoded from the server response.
struct Resource<T: Codable> {
  let url: URL                     // Endpoint URL
  var method: HTTPMethod = .get([]) // HTTP method (defaults to GET)
  var headers: [String: String]? = nil // Optional additional headers
  var modelType: T.Type             // Type of model expected in response
}

// MARK: - HTTPClient
// Wrapper around URLSession for performing API requests, decoding results,
// and handling token refresh logic.
struct HTTPClient {
  private let session: URLSession

  // Custom initializer that sets up a URLSession with default JSON headers.
  init() {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
    self.session = URLSession(configuration: configuration)
  }

  // MARK: - load()
  // Public method to load a given resource and decode it to the specified type.
  // It also handles automatic retry after token refresh if a 401 occurs.
  func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
    do {
      // Try performing the request normally
      return try await performRequest(resource)
    } catch NetworkError.unauthorized {
      // If unauthorized, attempt token refresh
      do {
        try await refreshToken()
        // Retry the request after refreshing tokens
        return try await performRequest(resource)
      } catch {
        // If refresh fails, throw invalid response
        throw NetworkError.invalidResponse
      }
    }
  }

  // MARK: - performRequest()
  // Builds and executes the network request, decodes response, and handles errors.
  private func performRequest<T: Codable>(_ resource: Resource<T>) async throws -> T {
    var request = URLRequest(url: resource.url)

    // Configure request based on HTTP method
    switch resource.method {
    case .get(let queryItems):
      // Attach query parameters to URL
      var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
      components?.queryItems = queryItems
      guard let url = components?.url else {
        throw NetworkError.badRequest
      }
      request.url = url

    case .post(let data), .put(let data):
      // POST/PUT: set method name and body
      request.httpMethod = resource.method.name
      request.httpBody = data

    case .delete:
      // DELETE: set method name only
      request.httpMethod = resource.method.name
    }

    // MARK: - Authorization Header
    // Add Bearer token from Keychain if available
    let keychain = KeychainWrapper.standard
    if let token = try? keychain.accessToken() {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    // Add any additional headers provided by the caller
    if let headers = resource.headers {
      for (key, value) in headers {
        request.setValue(value, forHTTPHeaderField: key)
      }
    }

    // MARK: - Execute request
    let (data, response) = try await session.data(for: request)

    // Validate the HTTP response
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.invalidResponse
    }

    // Handle HTTP status codes
    switch httpResponse.statusCode {
    case 200..<300:
      // Success — proceed to decoding
      break
    case 401:
      // Unauthorized — trigger refresh flow
      throw NetworkError.unauthorized
    case 404:
      throw NetworkError.notFound
    default:
      // Anything else is treated as undefined
      throw NetworkError.undefined(data, httpResponse)
    }

    // MARK: - Decode JSON
    // Attempt to decode response body into expected model type
    do {
      return try JSONDecoder().decode(resource.modelType, from: data)
    } catch {
      throw NetworkError.decodingError(error)
    }
  }

  // MARK: - refreshToken()
  // Called when a request fails with a 401 — refreshes tokens and retries request.
  func refreshToken() async throws {
    let keychain = KeychainWrapper.standard

    // Retrieve refresh token from Keychain
    guard let refreshToken = try keychain.refreshToken() else {
      throw NetworkError.unauthorized
    }

    // Encode refresh token in request body
    let body = try JSONEncoder().encode(["refreshToken": refreshToken])

    // Create a Resource representing the refresh token endpoint
    let resource = Resource(
      url: Constants.Urls.users,
      method: .post(body),
      modelType: RefreshTokenResponse.self
    )

    // Execute refresh request
    let response = try await performRequest(resource)

    // Save new Access & Refresh tokens back to the Keychain
    try? keychain.setAccessToken(response.accessToken)
    try? keychain.setRefreshToken(response.refreshToken)
  }
}

