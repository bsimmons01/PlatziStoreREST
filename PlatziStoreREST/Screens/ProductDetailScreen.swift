//
//  ProductDetailScreen.swift
//  Platzi
//
//  Created by Brian Simmons on 10/8/25.
//

import SwiftUI

struct ProductDetailScreen: View {
  let product: ProductResponse
  var onDelete: ((ProductResponse) -> Void)? = nil
  @Environment(PlatziStore.self) private var store
  @Environment(\.dismiss) private var dismiss

  @State private var showConfirmDialog = false

  var body: some View {
    ScrollView {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(product.images, id: \.self) { imageURL in
            AsyncImage(url: imageURL) { image in
              image
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipped()
                .cornerRadius(12)
            } placeholder: {
              RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 200, height: 200)
                .overlay(ProgressView())
            }
          }
        }
        .padding(.horizontal)
      }

      VStack(alignment: .leading) {
        Text(product.title)
          .font(.title)
          .fontWeight(.bold)

        Text("$\(product.price, specifier: "%.2f")")
          .font(.headline)
          .padding(.vertical, 2)

        Text(product.description)
          .font(.body)
          .foregroundStyle(.secondary)
      }
      .padding(.leading, 10)
      .padding(.trailing, 10)
      .frame(maxWidth: .infinity, alignment: .leading)
      .toolbar(content: {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            showConfirmDialog = true
          } label: {
            Image(systemName: "trash")
          }
          .accessibilityLabel("Delete Product")
        }
      })
      .confirmationDialog("* Product Deletion *", isPresented: $showConfirmDialog, titleVisibility: .visible) {
          Button("Delete Product", role: .destructive) {
            Task {
              await deleteProduct()
            }
          }
        Button("Cancel", role: .cancel) { }
      } message: {
        Text("Are you sure you want to delete this product?")
      }
    }
    .navigationTitle(product.title)
  }

  private func deleteProduct() async {
    do {
      if try await store.deleteProduct(product.id) {
        await MainActor.run {
          onDelete?(product)   // notify parent
          dismiss()            // pop detail
        }
      }
    } catch {
      print("🗣️ Delete failed for id \(product.id): \(error.localizedDescription)")
    }
  }
}

#Preview {
  NavigationStack {
    ProductDetailScreen(product: ProductResponse.preview)
  }
  .environment(PlatziStore(httpClient: HTTPClient()))
}
