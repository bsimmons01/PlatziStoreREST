//
//  RegistrationScreen.swift
//  Platzi
//
//  Created by Brian Simmons on 10/7/25.
//

import SwiftUI

struct RegistrationScreen: View {
  @Environment(\.authenticationController) private var authenticationController
  @Environment(\.dismiss) private var dismiss

  @State private var registrationForm: RegistrationForm = .init()
  @State private var errors: [String] = []
  @State private var messageText: String?
  @State private var registrationSuccess: Bool = false

  @Binding var loginEmail: String
  @Binding var loginPassword: String

  var body: some View {
    VStack(spacing: 0) {
      PlatziHeaderImageView()

      Form {
        Section(header: PlatziHeaderTextView(headerText: "Platzi Registration")) {
          registrationInputs

          if !errors.isEmpty {
            // display all errors
            ValidationSummaryView(errors: errors)
          }

          DemoPurposesView()
        }

        // For debugging purposes:
        //      if let messageText {
        //        Text(messageText)
        //          .foregroundStyle(messageText.contains("❌") ? .red : .green)
        //          .multilineTextAlignment(.center)
        //      }
      }
      .scrollContentBackground(.hidden) // hides the default Form background
      .background(Color.clear)          // makes it transparent

      registerCancelButtons
    }
    .alert("Registration Successful", isPresented: $registrationSuccess) {
      Button("OK") {
        dismiss()
      }
    } message: {
      Text("You may now login")
    }
  }

  // MARK: Registration inputs
  @ViewBuilder
  var registrationInputs: some View {
    TextField("Full Name (Can be fake)", text: $registrationForm.name)
      .textFieldStyle(.roundedBorder)
    TextField("Email (Recommend a fake email)", text: $registrationForm.email)
      .keyboardType(.emailAddress)
      .textInputAutocapitalization(.never)
      .textFieldStyle(.roundedBorder)

    SecureField("Password (A fake password)", text: $registrationForm.password)
      .textInputAutocapitalization(.never)
      .textFieldStyle(.roundedBorder)
  }

  // MARK: Register and Cancel buttons
  @ViewBuilder
  var registerCancelButtons: some View {
    VStack {
      HStack(spacing: 12) {
        Button {
          errors = registrationForm.validate()
          Task { await register() }
        } label: {
          Text("Register")
            .frame(minWidth: 0)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(!registrationForm.isValid ? Color.gray : Color.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(!registrationForm.isValid)

        Button {
          dismiss()
        } label: {
          Text("Cancel")
            .frame(minWidth: 0)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.red)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
      }

      .padding(.horizontal)
      .padding(.top, 8)
    }
  }

  private func register() async {
    do {
      let response = try await authenticationController.register(
        name: registrationForm.name,
        email: registrationForm.email,
        password: registrationForm.password
      )
      await MainActor.run {
        // prefill the login fields in the presenting view
        loginEmail = registrationForm.email
        loginPassword = registrationForm.password
        
        registrationSuccess = true
        messageText = "✅ User \(response.name) registered successfully"

        UserDefaults.standard.set(registrationForm.email, forKey: Constants.SettingsKeys.registeredEmail)
        UserDefaults.standard.set(registrationForm.name, forKey: Constants.SettingsKeys.registeredName)
      }
    } catch {
      messageText = "❌ Error: \(error.localizedDescription)"
    }
  }
}

// The data couldn't be read because it is missing
extension RegistrationScreen {
  private struct RegistrationForm {
    var name: String = ""
    var email: String = ""
    var password: String = ""

    //    var name: String = "Jane Doe"
    //    var email: String = "jdoe@test.com"
    //    var password: String = "Test12345"

    var isValid: Bool {
      validate().isEmpty
    }

    func validate() -> [String] {
      var errors: [String] = []

      if name.isEmptyOrWhitespace {
        errors.append("Name cannot be empty")
      }

      if email.isEmptyOrWhitespace {
        errors.append("Email cannot be empty")
      }

      if password.isEmptyOrWhitespace {
        errors.append("Password cannot be empty")
      }

      if !password.isValidPassword {
        errors.append("Password must be 8–17 characters long, include uppercase, lowercase, numeric, and no special characters or spaces")
      }

      if !email.isEmail {
        errors.append("Email must be in correct format")
      }

      return errors
    }
  }
}

#Preview {
  RegistrationScreen(
    loginEmail: .constant("jane@doe.com"),
    loginPassword: .constant("Test1234")
  )
}
