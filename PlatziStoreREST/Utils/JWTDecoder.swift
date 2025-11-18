//
//  JWTDecoder.swift
//  Platzi
//
//  Created by Brian Simmons on 10/7/25.
//

import Foundation

// MARK: - JWTDecoder
// Utility for decoding and inspecting JSON Web Tokens (JWTs).
// Used primarily to check token expiration without relying on external libraries.
struct JWTDecoder {

  // MARK: - Expiration Check
  /// Determines whether a given JWT access token is expired.
  /// - Parameter token: The JWT string (e.g., "header.payload.signature").
  /// - Returns: `true` if the token is expired or invalid, otherwise `false`.
  static func isExpired(token: String) -> Bool {
    // Try decoding the payload section of the token
    guard let payload = try? decodePayload(token),
          let exp = payload["exp"] as? TimeInterval else {
      // If decoding fails or "exp" claim is missing, treat as expired
      return true
    }

    // Debug printouts for inspection (can remove in production)
    print("💰 payload: \(payload)")
    print("📆 exp. date: \(exp)")

    // Compare the current timestamp with the expiration timestamp
    return Date().timeIntervalSince1970 > exp
  }

  // MARK: - Decode Payload
  /// Decodes and returns the JWT payload as a dictionary.
  /// - Parameter token: The full JWT string.
  /// - Throws: `JWTError` if format, base64, or JSON parsing fails.
  /// - Returns: A `[String: Any]` dictionary representing the token’s payload.
  static func decodePayload(_ token: String) throws -> [String: Any] {
    // JWT format: header.payload.signature (three base64url-encoded parts)
    let segments = token.split(separator: ".")
    guard segments.count >= 2 else {
      throw JWTError.invalidFormat // Not enough parts to be a valid JWT
    }

    // The payload is the second segment of the token
    let payloadSegment = segments[1]

    // MARK: - Base64URL → Base64 Conversion
    // JWTs use base64url encoding, so we must replace URL-safe characters
    var base64 = payloadSegment
      .replacingOccurrences(of: "-", with: "+")
      .replacingOccurrences(of: "_", with: "/")

    // Add padding characters ("=") if necessary to make valid base64 length
    let paddingLength = 4 - (base64.count % 4)
    if paddingLength < 4 {
      base64 += String(repeating: "=", count: paddingLength)
    }

    // Decode base64 string into raw Data
    guard let data = Data(base64Encoded: base64) else {
      throw JWTError.invalidBase64
    }

    // Attempt to parse JSON from the decoded Data
    let json = try JSONSerialization.jsonObject(with: data, options: [])

    // Ensure the payload is a key-value dictionary
    guard let payload = json as? [String: Any] else {
      throw JWTError.invalidJSON
    }

    // Return successfully decoded payload
    return payload
  }

  // MARK: - JWTError
  /// Enumerates possible decoding errors for JWT processing.
  enum JWTError: Error {
    case invalidFormat   // Token missing required segments
    case invalidBase64   // Base64 decoding failed
    case invalidJSON     // Payload was not valid JSON
  }
}

