//
//  Encodable+Extensions.swift
//  Platzi
//
//  Created by Brian Simmons on 10/7/25.
//

import Foundation

// MARK: - Encodable Extension
// Adds a convenience helper method to any type conforming to Encodable.
// This makes it easier to quickly convert models into JSON Data
// for use in HTTP request bodies.
extension Encodable {
  /// Encodes the conforming object into `Data` using `JSONEncoder`.
  /// - Throws: An error if the encoding fails (e.g., invalid model structure).
  /// - Returns: A `Data` object representing the JSON-encoded model.
  func encode() throws -> Data {
    // Create a new JSON encoder instance
    let encoder = JSONEncoder()

    // Encode `self` (the current object) into Data
    // If encoding fails, the error will be propagated to the caller
    return try encoder.encode(self)
  }
}

