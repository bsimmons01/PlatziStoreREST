//
//  CategoryAddScreen.swift
//  Platzi
//
//  Created by Brian Simmons on 10/8/25.
//

import SwiftUI

struct CategoryAddScreen: View {
  @Environment(PlatziStore.self) private var store
  @Environment(\.dismiss) private var dismiss

  @State private var name: String = ""
  @State private var saveTapped: Bool = false
  @State private var showDuplicateAlert = false
  @State private var attemptedName = ""

  private var isFormValid: Bool {
    !name.isEmptyOrWhitespace
  }

  private var isDuplicateName: Bool {
    let target = name.normalizedForComparison
    guard !target.isEmpty else { return false }
    return store.categories.contains { $0.name.normalizedForComparison == target }
  }

  var body: some View {
    Form {
      TextField("Category Name", text: $name)

      if isDuplicateName && !saveTapped {
        Text("That category already exists").foregroundStyle(.red)
      }
    }
    .navigationTitle("Add New Category")
    .alert("Duplicate Category", isPresented: $showDuplicateAlert) {
      Button("OK", role: .cancel) {}
    } message: {
      Text("“\(attemptedName)” already exists. Please choose a different name.")
    }
    .toolbar(content: {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          Task {
            await addCategory()
          }
        } label: {
          Text("Save")
        }
        .accessibilityLabel("Save New Category")
        .disabled(!isFormValid || saveTapped)
      }
    })
  }

  private func addCategory() async {
    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }

    if isDuplicateName {
      attemptedName = trimmed
      showDuplicateAlert = true
      return
    }

    saveTapped = true

    do {
      try await store.addCategory(name: trimmed)
      dismiss()
      // No need to reset saveTapped; view is going away
    } catch {
      // Only reset on failure so user can try again
      saveTapped = false
      print("😿 Error adding category: \(error.localizedDescription)")
    }
  }
}

#Preview {
  NavigationStack {
    CategoryAddScreen()
      .environment(PlatziStore(httpClient: HTTPClient()))
  }
}
