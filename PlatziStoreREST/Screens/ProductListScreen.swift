//
//  ProductListScreen.swift
//  Platzi
//
//  Created by Brian Simmons on 10/8/25.
//

import SwiftUI

struct ProductListScreen: View {
  @Environment(PlatziStore.self) private var store
  @State private var products: [ProductResponse] = []
  @State private var isLoading = true
  @State private var searchText = ""
  @State private var showAddProductScreen: Bool = false

  let category: CategoryResponse

  private var filteredProducts: [ProductResponse] {
    let q = searchText.normalizedForSearch
    guard !q.isEmpty else { return products }

    return products.filter { p in
      p.title.containsNormalized(q)
//      || p.description.containsNormalized(q)
//      || p.slug.containsNormalized(q)
//      || p.category.name.containsNormalized(q)
    }
  }

  var body: some View {
    ZStack {
      if filteredProducts.isEmpty && !isLoading {
        if searchText.isEmptyOrWhitespace {
          ContentUnavailableView("No products found", systemImage: "shippingbox")
        } else {
          ContentUnavailableView {
            Label("No results", systemImage: "magnifyingglass")
          } description: {
            Text("No matches for “\(searchText)”. Try a different keyword.")
          }
        }
      } else {
        List {
          ForEach(filteredProducts, id: \.id) { product in
            NavigationLink {
              ProductDetailScreen(product: product) { deleted in
                withAnimation {
                  products.removeAll { $0.id == deleted.id }
                }
              }
            } label: {
              ProductRowView(product: product)
            }
          }
          .onDelete(perform: deleteProducts)
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
        .refreshable {
          if !isLoading {
            await loadProducts()
          }
        }
      }
    }
    .navigationTitle(category.name)
    .navigationBarTitleDisplayMode(.inline)
    .searchable(
      text: $searchText,
      placement: .navigationBarDrawer(displayMode: .always),
      prompt: "Search products"
    )
    .toolbar(content: {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          showAddProductScreen = true
        } label: {
          Image(systemName: "plus.diamond.fill")
        }
        .accessibilityLabel("Add New Product")
      }
    })
    .sheet(isPresented: $showAddProductScreen, content: {
      NavigationStack {
        ProductAddScreen(selectedCategory: category) { product in
          products.append(product)
        }
      }
    })
    .overlay(alignment: .center, content: {
      if isLoading {
        ProgressView("Loading Products for \(category.name)...")
      }
    })
    .task {
      await loadProducts()
    }
  }

  private func loadProducts() async {
    guard !isLoading || products.isEmpty else { return }
    defer {isLoading = false}
    isLoading = true
    do {
      products = try await store.fetchProductsByCategoryId(category.id)
    } catch {
      print("😵 Error fetching products: \(error.localizedDescription)")
    }
  }

  private func deleteProducts(at offsets: IndexSet) {
    let itemsToDelete = offsets.map { filteredProducts[$0] }

    Task {
      for item in itemsToDelete {
        do {
          if try await store.deleteProduct(item.id) {
            await MainActor.run {
              withAnimation {
                products.removeAll { $0.id == item.id }
              }
            }
          }
        } catch {
          print("🧹 Delete failed for id \(item.id): \(error.localizedDescription)")
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    ProductListScreen(category: CategoryResponse(id: 1, name: "Shoes", slug: "shoes", image: URL.randomProductImageURL))
      .environment(PlatziStore(httpClient: HTTPClient()))
  }
}
