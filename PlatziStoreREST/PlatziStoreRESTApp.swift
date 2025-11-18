//
//  PlatziStoreRESTApp.swift
//  PlatziStoreREST
//
//  Created by Brian Simmons on 11/18/25.
//

import SwiftUI

@main
struct PlatziStoreRESTApp: App {
  @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
  @Environment(\.authenticationController) private var authenticationController
  @State private var store = PlatziStore(httpClient: HTTPClient())
  @State private var isLoading: Bool = true

  var body: some Scene {
    WindowGroup {
      ZStack {
        if isLoading {
          ProgressView("Authenticating...")
            .task {
              isAuthenticated = await authenticationController.checkAuthentication()
              isLoading = false
            }
        } else if isAuthenticated {
          HomeScreen()
            .environment(store)
        } else {
          VStack {
            //RegistrationScreen()
            LoginScreen()
          }
        }
      }
    }
  }

}
