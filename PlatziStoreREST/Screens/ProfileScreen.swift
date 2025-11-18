//
//  ProfileScreen.swift
//  Platzi
//
//  Created by Brian Simmons on 10/8/25.
//

import SwiftUI

struct ProfileScreen: View {
  @Environment(\.authenticationController) private var authenticationController
  @Environment(\.colorScheme) private var colorScheme

  @AppStorage(Constants.SettingsKeys.registeredEmail) private var registeredEmail: String = ""
  @AppStorage(Constants.SettingsKeys.registeredName) private var registeredName: String = ""

  private var appName: String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    ?? "App"
  }
  private var version: String {
    (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "—"
  }
  private var build: String {
    (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "—"
  }
  private var currentYear: String {
    String(Calendar.current.component(.year, from: Date()))
  }

  var body: some View {
    ScrollView {
      HStack {
        Text("\(registeredName) [\(registeredEmail)]")
          .font(.title3)
          .padding(.bottom)

      }

      Button(action: {
        authenticationController.signOut()

        UserDefaults.standard.set("", forKey: Constants.SettingsKeys.registeredEmail)
        UserDefaults.standard.set("", forKey: Constants.SettingsKeys.registeredName)
      }) {
        Text("Sign Out")
          .font(.headline)
          .fontWeight(.bold)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.red.opacity(0.2))
          .foregroundStyle(.black)
          .cornerRadius(12)
      }


      ZStack {
        LinearGradient(
          colors: colorScheme == .dark
          ? [.indigo.opacity(0.4), .blue.opacity(0.4)]
          : [.blue.opacity(0.4), .cyan.opacity(0.4)],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

        VStack(spacing: 10) {
          Image("AppIcon1024")
            .resizable()
            .scaledToFit()
            .frame(width: 80)
            .cornerRadius(12)
            .padding(.top, 15)
            .shadow(color: .black.opacity(0.8), radius: 10, x: 5, y: 5)

          Text("Platzi SwiftUI Demo")
            .font(.title.bold())
            .lineLimit(1)

          Text("Version \(version) • Build \(build)")
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .padding()
      }
      .accessibilityElement(children: .combine)

      LicenseView()
    }
    .padding(.horizontal)
    .padding(.bottom, 50)
    .navigationTitle("Profile")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationStack {
    ProfileScreen()
  }
}
