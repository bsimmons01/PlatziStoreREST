//
//  AddProductScreen.swift
//  Platzi
//
//  Created by Brian Simmons on 10/8/25.
//

import SwiftUI

struct ProductAddScreen: View {
  @Environment(PlatziStore.self) private var store
  @Environment(\.dismiss) private var dismiss

  @State private var title: String = ""
  @State private var price: Double?
  @State private var description: String = ""
  @State private var selectedCategory: CategoryResponse

  let onSave: (ProductResponse) -> Void

  init(selectedCategory: CategoryResponse = CategoryResponse.preview, onSave: @escaping (ProductResponse) -> Void) {
    self.selectedCategory = selectedCategory
    self.onSave = onSave
  }

  private var isFormValid: Bool {
    !title.isEmptyOrWhitespace && !description.isEmptyOrWhitespace && price != nil && price! > 0
  }

  var body: some View {
    Form {
      Text("\(selectedCategory.name)")
        .font(.title3)
        .fontWeight(.bold)

      TextField("Title", text: $title)
      TextField("Price", value: $price, format: .number)
        .keyboardType(.decimalPad)
      ZStack(alignment: .topLeading) {
        TextEditor(text: $description)
          .frame(height: 100)
          .padding(.top, 8) // gives room so text doesn't overlap

        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          Text("Description")
            .foregroundStyle(.secondary.opacity(0.5))
            .padding(.horizontal, 5)
            .padding(.vertical, 12)
            .allowsHitTesting(false) // taps go to the editor
        }
      }
    }
    .toolbar(content: {
      ToolbarItem(placement: .topBarLeading) {
        Button("Cancel") {
          dismiss()
        }
      }

      ToolbarItem(placement: .topBarTrailing) {
        Button("Add Product") {
          Task {
            await addProduct()
          }
        }
        .disabled(!isFormValid)
      }
    })
  }

  private func addProduct() async {
    guard let price = price else { return }

    do {
      let product = try await store.addProduct(title: title, price: price, description: description, categoryId: selectedCategory.id, images: URL.randomProductImageURLs)
      onSave(product)
      dismiss()
    } catch {
      print("📢 Error adding Product: \(error.localizedDescription)")
    }

  }
}

#Preview {
  NavigationStack {
    ProductAddScreen(selectedCategory: CategoryResponse.preview, onSave: { _ in })
      .environment(PlatziStore(httpClient: HTTPClient()))
  }
}
