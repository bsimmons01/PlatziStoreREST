//
//  LoginScreen.swift
//  Platzi
//
//  Created by Brian Simmons on 10/7/25.
//

import SwiftUI

struct LoginScreen: View {
  @Environment(\.authenticationController) private var authenticationController

  @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false

  @State private var email: String = ""
  @State private var password: String = ""

  @State private var showingRegistration = false
  @State private var errorLoggingIn = false
  @State private var errorLogginInText = ""

  private var isFormValid: Bool {
    !email.isEmptyOrWhitespace && !password.isEmptyOrWhitespace && email.isEmail
  }

  var body: some View {
    ZStack {
      VStack {
        PlatziHeaderImageView()

        Form {
          Section(header: PlatziHeaderTextView(headerText: "Platzi Login")) {
            emailPasswordInputs

            Section {
              loginButton
            }
          }

          if errorLoggingIn {
            Section {
              loginIssues
            }
            .listRowBackground(Color.clear)
            .transition(.move(edge: .top).combined(with: .opacity))
          }

          Section {
            createAccount
          }
          .listRowBackground(Color.clear)

          LicenseView()
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)

      }
    }
    // Full-screen cover that slides up
    .fullScreenCover(isPresented: $showingRegistration) {
      RegistrationScreen(loginEmail: $email, loginPassword: $password)
    }
  }

  // MARK: Email/Password inputs
  @ViewBuilder
  var emailPasswordInputs: some View {
    TextField("Email", text: $email)
      .keyboardType(.emailAddress)
      .textInputAutocapitalization(.never)
      .textFieldStyle(.roundedBorder)

    SecureField("Password", text: $password)
      .textInputAutocapitalization(.never)
      .textFieldStyle(.roundedBorder)
  }

  // MARK: Login Button input
  @ViewBuilder
  var loginButton: some View {
    Button {
      Task { await login() }
    } label: {
      Text("Login")
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .padding()
        .background(isFormValid ? Color.blue : Color.gray)
        .cornerRadius(8)
    }
    .disabled(!isFormValid)
    .listRowBackground(Color.clear)
  }

  // MARK: Ability To Create A New Account
  @ViewBuilder
  var createAccount: some View {
    HStack(spacing: 6) {
      Text("Don't have a valid account?")
        .font(.subheadline)
        .foregroundStyle(.primary)
      Button("Create one for free") {
        showingRegistration = true
      }
      .buttonStyle(.plain)
      .font(.subheadline.weight(.semibold))
      .foregroundStyle(.blue)
      .underline()
      .accessibilityLabel("Create a free Platzi account")
      .accessibilityHint("Opens the registration screen")
    }
    .frame(maxWidth: .infinity, alignment: .center)
    .padding(.vertical, 4)
  }

  // MARK: Error Messaging on Login issues
  @ViewBuilder
  var loginIssues: some View {
    HStack(spacing: 6) {
      Image(systemName: "exclamationmark.triangle.fill")
        .foregroundStyle(.red)
      Text(errorLogginInText)
        .foregroundStyle(.red)
        .font(.subheadline)
        .multilineTextAlignment(.leading)
        .contentTransition(.opacity) // iOS 17+
    }
    .frame(maxWidth: .infinity, alignment: .center)
    .padding(.vertical, 6)
  }

  private func login() async {
    do {
      withAnimation { errorLoggingIn = false }
      errorLogginInText = ""
      isAuthenticated = try await authenticationController.login(email: email, password: password)
    } catch {
      withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
        errorLoggingIn = true
        errorLogginInText = error.localizedDescription
      }
    }
  }
}

#Preview {
  LoginScreen()
}
