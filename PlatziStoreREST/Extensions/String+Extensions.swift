//
//  String+Extensions.swift
//  Platzi
//
//  Created by Brian Simmons on 10/7/25.
//

import Foundation

// MARK: - String Extension
// Adds common String utilities for validation, normalization, and comparison.
// These helpers make text handling more consistent and readable across the app.

extension String {
  // MARK: - Empty or Whitespace
  /// Returns `true` if the string is empty or contains only whitespace/newline characters.
  var isEmptyOrWhitespace: Bool {
    trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  // MARK: - Normalized for Comparison
  /// Returns a lowercased, accent-insensitive, and trimmed version of the string.
  /// Useful for comparing user input or search queries fairly, regardless of case or accents.
  var normalizedForComparison: String {
    trimmingCharacters(in: .whitespacesAndNewlines)
      .folding(options: .diacriticInsensitive, locale: .current) // Removes accents (e.g., "é" → "e")
      .lowercased() // Converts to lowercase for case-insensitive comparison
  }

  // MARK: - Password Validation
  /// Returns `true` if the string meets custom password rules:
  /// - Between 8 and 17 characters
  /// - Contains at least one uppercase letter
  /// - Contains at least one lowercase letter
  /// - Contains at least one digit
  /// - No spaces or special characters (letters and numbers only)
  var isValidPassword: Bool {
    // Must be between 8 and 17 characters
    guard count >= 8 && count < 18 else { return false }

    // Must not contain spaces or tabs
    guard !contains(" ") && !contains("\t") else { return false }

    // Must contain at least one uppercase letter
    guard range(of: "[A-Z]", options: .regularExpression) != nil else { return false }

    // Must contain at least one lowercase letter
    guard range(of: "[a-z]", options: .regularExpression) != nil else { return false }

    // Must contain at least one number
    guard range(of: "[0-9]", options: .regularExpression) != nil else { return false }

    // Must contain only letters and numbers (no special characters)
    guard range(of: "^[A-Za-z0-9]+$", options: .regularExpression) != nil else { return false }

    return true
  }

  // MARK: - Email Validation
  /// Returns `true` if the string matches a simple email regex pattern.
  /// (Checks for presence of '@', domain, and TLD.)
  var isEmail: Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    return range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
  }

  // MARK: - Normalized for Search
  /// Returns a normalized version of the string for search purposes.
  /// Similar to `normalizedForComparison`, ensures consistent matching regardless of accents or case.
  var normalizedForSearch: String {
    trimmingCharacters(in: .whitespacesAndNewlines)
      .folding(options: .diacriticInsensitive, locale: .current)
      .lowercased()
  }

  // MARK: - Contains Normalized
  /// Checks if this string contains another string,
  /// using normalized (trimmed, accent-insensitive, lowercase) comparison.
  func containsNormalized(_ other: String) -> Bool {
    normalizedForSearch.contains(other.normalizedForSearch)
  }
}

