//
//  KeychainWrapper.swift
//  Platzi
//
//  Created by Brian Simmons on 10/7/25.
//

/*
 Usage:
 let keychain = KeychainWrapper.standard

 // Save
 try? keychain.setAccessToken("abc123")
 try? keychain.setRefreshToken("def456")

 // Read
 let access = try? keychain.accessToken()
 let refresh = try? keychain.refreshToken()

 // Delete one
 try? keychain.delete(KeychainWrapper.Key.accessToken)

 // Wipe both
 try? keychain.deleteTokens()

 // Wipe everything under this service
 try? keychain.removeAll()

 */

import Foundation
import Security

public struct KeychainWrapper {
  public enum KeychainError: Error, LocalizedError {
    case stringEncodingError
    case itemNotFound
    case duplicateEntry
    case unexpectedStatus(OSStatus)

    public var errorDescription: String? {
      switch self {
      case .stringEncodingError: return "Failed to encode/decode string as UTF-8."
      case .itemNotFound:        return "Keychain item not found."
      case .duplicateEntry:      return "Duplicate Keychain entry."
      case .unexpectedStatus(let status): return "Keychain error: \(status)."
      }
    }
  }

  // MARK: - Configuration
  public let service: String
  public let accessGroup: String?

  /// A convenient default configured with your bundle identifier as the service.
  public static let standard = KeychainWrapper(
    service: Bundle.main.bundleIdentifier ?? "com.centrasoft.Platzi",
    accessGroup: nil
  )

  public init(service: String, accessGroup: String? = nil) {
    self.service = service
    self.accessGroup = accessGroup
  }

  // MARK: - Public API (Strings)

  /// Inserts or updates a string value for a given key.
  public func set(
    _ value: String,
    for key: String,
    accessibility: CFString = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
  ) throws -> Void {
    guard let data = value.data(using: .utf8) else { throw KeychainError.stringEncodingError }

    // Base query identifies the item
    var query: [String: Any] = [
      kSecClass as String:            kSecClassGenericPassword,
      kSecAttrService as String:      service,
      kSecAttrAccount as String:      key
    ]
    if let accessGroup { query[kSecAttrAccessGroup as String] = accessGroup }

    // Attributes to set/update
    let attributes: [String: Any] = [
      kSecValueData as String:        data,
      kSecAttrAccessible as String:   accessibility
    ]

    // Try add first
    var status = SecItemAdd(query.merging(attributes) { _, new in new } as CFDictionary, nil)

    if status == errSecDuplicateItem {
      // Update existing
      status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    }

    guard status == errSecSuccess else { throw KeychainError.unexpectedStatus(status) }
  }

  /// Reads a string for the given key. Returns `nil` if not found.
  public func get(_ key: String) throws -> String? {
    var query: [String: Any] = [
      kSecClass as String:            kSecClassGenericPassword,
      kSecAttrService as String:      service,
      kSecAttrAccount as String:      key,
      kSecMatchLimit as String:       kSecMatchLimitOne,
      kSecReturnData as String:       true
    ]
    if let accessGroup { query[kSecAttrAccessGroup as String] = accessGroup }

    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)

    if status == errSecItemNotFound { return nil }
    guard status == errSecSuccess, let data = result as? Data else {
      throw KeychainError.unexpectedStatus(status)
    }
    guard let string = String(data: data, encoding: .utf8) else {
      throw KeychainError.stringEncodingError
    }
    return string
  }

  /// Deletes a single key.
  public func delete(_ key: String) throws {
    var query: [String: Any] = [
      kSecClass as String:            kSecClassGenericPassword,
      kSecAttrService as String:      service,
      kSecAttrAccount as String:      key
    ]
    if let accessGroup { query[kSecAttrAccessGroup as String] = accessGroup }

    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainError.unexpectedStatus(status)
    }
  }

  /// Deletes all keys under this `service` (and access group if set).
  public func removeAll() throws {
    var query: [String: Any] = [
      kSecClass as String:            kSecClassGenericPassword,
      kSecAttrService as String:      service
    ]
    if let accessGroup { query[kSecAttrAccessGroup as String] = accessGroup }

    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainError.unexpectedStatus(status)
    }
  }
}

// MARK: - Convenience keys for tokens
public extension KeychainWrapper {
  enum Key {
    public static let accessToken  = "access_token"
    public static let refreshToken = "refresh_token"
  }

  func setAccessToken(_ token: String) throws {
    try set(token, for: Key.accessToken)
  }

  func accessToken() throws -> String? {
    try get(Key.accessToken)
  }

  func setRefreshToken(_ token: String) throws {
    try set(token, for: Key.refreshToken)
  }

  func refreshToken() throws -> String? {
    try get(Key.refreshToken)
  }

  func deleteTokens() throws {
    try delete(Key.accessToken)
    try delete(Key.refreshToken)
  }
}
