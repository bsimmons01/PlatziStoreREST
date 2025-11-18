//
//  CategoryListScreen.swift
//  Platzi
//
//  Created by Brian Simmons on 10/8/25.
//

import SwiftUI

struct CategoryListScreen: View {
  @Environment(PlatziStore.self) private var store
  @State private var isLoading = true
  @State private var showAddCategoryScreen: Bool = false
  @State private var searchText = ""

  private var filteredCategories: [CategoryResponse] {
    let q = searchText.normalizedForSearch
    guard !q.isEmpty else { return store.categories }

    return store.categories.filter { c in
      c.name.containsNormalized(q)
    }
  }

  var body: some View {
    ZStack {
      if filteredCategories.isEmpty && !isLoading {
        if searchText.isEmptyOrWhitespace {
          ContentUnavailableView("No Categories found", systemImage: "shippingbox")
        } else {
          ContentUnavailableView {
            Label("No results", systemImage: "magnifyingglass")
          } description: {
            Text("No matches for “\(searchText)”. Try a different keyword.")
          }
        }
      } else {
        List(filteredCategories) { category in
          NavigationLink {
            ProductListScreen(category: category)
          } label: {
            CategoryRowView(category: category)
          }
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
        .refreshable {
          if !isLoading {
            await loadCategories()
          }
        }
      }
    }
    .navigationTitle("Categories")
    .navigationBarTitleDisplayMode(.inline)
    .searchable(
      text: $searchText,
      placement: .navigationBarDrawer(displayMode: .always),
      prompt: "Search Categories"
    )
    .toolbar(content: {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          showAddCategoryScreen = true
        } label: {
          Image(systemName: "rectangle.stack.fill.badge.plus")
        }
        .accessibilityLabel("Add New Category")
      }
    })
    .sheet(isPresented: $showAddCategoryScreen, content: {
      NavigationStack {
        CategoryAddScreen()
      }
    })
    .overlay(alignment: .center, content: {
      if isLoading {
        ProgressView("Loading Categories...")
      }
    })
    .task {
      await loadCategories()
    }
  }

  private func loadCategories() async {
    defer {
      isLoading = false
    }
    do {
      isLoading = true
      try await store.loadCategories()
    } catch {
      print("🙀 Error fetching categories: \(error.localizedDescription)")
    }
  }
}

#Preview {
  NavigationStack {
    CategoryListScreen()
  }
  .environment(PlatziStore(httpClient: HTTPClient()))
}
