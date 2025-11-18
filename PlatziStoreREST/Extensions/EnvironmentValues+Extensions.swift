//
//  EnvironmentValues+Extensions.swift
//  Platzi
//
//  Created by Brian Simmons on 10/7/25.
//

import Foundation
import SwiftUI

// MARK: - EnvironmentValues Extension
// This extension adds a custom environment value for the `AuthenticationController`.
// It allows you to inject and access a shared authentication controller throughout
// your SwiftUI view hierarchy using the `@Environment` property wrapper.

extension EnvironmentValues {
  /// Custom environment entry for the app’s authentication controller.
  /// This provides global access to authentication logic (login, register, sign out, etc.)
  /// without needing to manually pass it down through multiple view initializers.
  @Entry var authenticationController = AuthenticationController(httpClient: HTTPClient())
}

