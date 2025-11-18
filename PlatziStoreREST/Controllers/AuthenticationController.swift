//
//  AuthenticationController.swift
//  Platzi
//
//  Created by Brian Simmons on 10/7/25.
//

import Foundation

// MARK: - AuthenticationController
// Handles all user authentication logic, including registration, login, token checks, and sign-out.
struct AuthenticationController {
  // HTTP client used for network requests.
  // Note: For unit tests, you could inject a mock that conforms to HTTPClientProtocol.
  let httpClient: HTTPClient

  // MARK: - Register
  /// Registers a new user with name, email, and password.
  /// Returns a `CreateUserResponse` model on success.
  func register(name: String, email: String, password: String) async throws -> CreateUserResponse {
    // Create the request body model (with a dummy avatar URL for demo purposes)
    let request = CreateUserRequest(
      name: name,
      email: email,
      password: password,
      avatar: URL(string: "https://picsum.photos/800")!
    )

    // Wrap in a Resource describing how to send the API call
    let resource = Resource(
      url: Constants.Urls.users,                // Endpoint for registration
      method: .post(try request.encode()),      // Encode request as JSON
      modelType: CreateUserResponse.self        // Expected response type
    )

    // Execute the network request through HTTPClient
    let response = try await httpClient.load(resource)

    // Return the decoded user creation response
    return response
  }

  // MARK: - Login
  /// Logs in an existing user and stores tokens in the Keychain.
  /// Returns true on success.
  func login(email: String, password: String) async throws -> Bool {
    // Create login request body
    let request = LoginRequest(email: email, password: password)

    // Define the login API resource
    let resource = Resource(
      url: Constants.Urls.login,                // Login endpoint
      method: .post(try request.encode()),      // POST request with encoded JSON
      modelType: LoginResponse.self             // Expect a LoginResponse
    )

    // Perform the network request
    let response = try await httpClient.load(resource)

    // Debug logs (helpful for verifying tokens during development)
    print("👁️ loginResponse.accessToken: \(response.accessToken)")
    print("👁️ loginResponse.refreshToken: \(response.refreshToken)")

    // MARK: - Store tokens securely
    let keychain = KeychainWrapper.standard

    // Save access and refresh tokens to Keychain for future API use
    try? keychain.setAccessToken(response.accessToken)
    try? keychain.setRefreshToken(response.refreshToken)

    return true
  }

  // MARK: - Check Authentication
  /// Verifies if the user is currently authenticated.
  /// If the access token is expired, attempts to refresh it.
  func checkAuthentication() async -> Bool {
    let keychain = KeychainWrapper.standard

    // Attempt to retrieve access token from Keychain
    guard let accessToken = try? keychain.accessToken() else {
      // If not found, user is not authenticated
      return false
    }

    // If token exists, check for expiration
    if JWTDecoder.isExpired(token: accessToken) {
      do {
        // Try to refresh access token if expired
        try await httpClient.refreshToken()
        return true
      } catch {
        // Refresh failed → user needs to log in again
        return false
      }
    }

    // Token is valid → user is authenticated
    return true
  }

  // MARK: - Sign Out
  /// Signs the user out by removing tokens and clearing local state.
  func signOut() {
    let keychain = KeychainWrapper.standard
    do {
      print("🚪 Signing out...")

      // Remove local authentication flag (if used elsewhere in app)
      UserDefaults.standard.removeObject(forKey: "isAuthenticated")

      // Clear access & refresh tokens from Keychain
      try keychain.setAccessToken("")
      try keychain.setRefreshToken("")

    } catch {
      // Handle unexpected Keychain errors
      print("🔑 Error removing keychain items: \(error)")
    }
  }
}

