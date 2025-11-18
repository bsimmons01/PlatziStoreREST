//
//  Errors.swift
//  Platzi
//
//  Created by Brian Simmons on 10/7/25.
//

import Foundation

// MARK: - NetworkError
// Represents possible networking and decoding errors encountered
// during API requests and responses.
enum NetworkError: Error {
  case badRequest                     // 400: Client sent a malformed request
  case decodingError(Error)           // Error occurred while decoding JSON
  case invalidResponse                // Response was not a valid HTTPURLResponse
  case unauthorized                   // 401: Token invalid or expired
  case notFound                       // 404: Resource could not be located
  case undefined(Data, HTTPURLResponse) // Any other unexpected status code; captures raw data & response
}

// MARK: - LocalizedError Conformance
// Provides user-readable descriptions for each error case.
// Useful for debugging and for displaying friendly messages to users.
extension NetworkError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .badRequest:
      // Occurs when the request parameters or format are invalid
      return "Bad request (400). The server could not process your request."

    case .decodingError(let error):
      // Thrown when JSONDecoder fails to parse the response data
      return "Failed to decode the server response: \(error.localizedDescription)"

    case .invalidResponse:
      // Response was not an HTTPURLResponse, or status code missing
      return "Invalid response from the server."

    case .unauthorized:
      // Usually caused by an expired or invalid access token
      return "Unauthorized (401). Please sign in again."

    case .notFound:
      // The requested endpoint or resource was not found
      return "Not found (404). The requested resource doesn’t exist."

    case let .undefined(data, http):
      // Handles all other status codes, capturing the raw response for diagnostics
      let bodyString = String(data: data, encoding: .utf8)?
        .trimmingCharacters(in: .whitespacesAndNewlines)

      // Show up to 500 characters of the body for easier debugging
      // If body is empty, display a placeholder; if not UTF-8, indicate that
      let preview = bodyString.map { str in
        let trimmed = str.isEmpty ? "<empty body>" : str
        return String(trimmed.prefix(500))
      } ?? "<non-UTF8 body>"

      // Returns a formatted message with status code and response snippet
      return "Unexpected server response (\(http.statusCode)). Body: \(preview)"
    }
  }
}

