//
//  PlatziStore.swift
//  Platzi
//
//  Created by Brian Simmons on 10/8/25.
//

import Foundation
import Observation

// MARK: - PlatziStore
// Main observable data store for the Platzi app.
// Acts as a shared source of truth for categories, locations, and product-related API calls.
// This class coordinates network requests using the shared HTTPClient and publishes updates to SwiftUI views.

@MainActor // Ensures all UI-related updates occur on the main thread
@Observable // Makes the class automatically observable in SwiftUI (iOS 17+ Observation framework)
class PlatziStore {
  // MARK: - Properties

  /// The HTTP client responsible for performing network requests.
  let httpClient: HTTPClient

  /// Cached list of product categories, updated when categories are loaded or added.
  var categories: [CategoryResponse] = []

  /// Cached list of available store locations.
  var locations: [LocationResponse] = []

  // MARK: - Initializer

  /// Initializes the store with a provided `HTTPClient`.
  /// - Parameter httpClient: The HTTP client used for all API calls.
  init(httpClient: HTTPClient) {
    self.httpClient = httpClient
  }

  // MARK: - Categories

  /// Loads all available product categories from the API and updates `categories`.
  func loadCategories() async throws {
    // Define the API resource (GET /categories)
    let resource = Resource(
      url: Constants.Urls.categories,
      modelType: [CategoryResponse].self
    )

    // Perform network call and assign to state property
    categories = try await httpClient.load(resource)
  }

  /// Adds a new product category and appends it to the `categories` list.
  /// - Parameter name: The name of the category to create.
  func addCategory(name: String) async throws {
    // Create request body model
    let addCategoryRequest = AddCategoryRequest(
      name: name,
      image: URL.randomCategoryImageURL // Use a random cateogry image for demo purposes
    )

    // Define resource for POST /categories
    let resource = Resource(
      url: Constants.Urls.addCategory,
      method: .post(try addCategoryRequest.encode()),
      modelType: CategoryResponse.self
    )

    // Execute network request
    let category = try await httpClient.load(resource)

    // Append new category to the observable list
    categories.append(category)
  }

  // MARK: - Products

  /// Fetches all products for a given category ID.
  /// - Parameter categoryId: The unique ID of the category.
  /// - Returns: An array of `ProductResponse` objects.
  func fetchProductsByCategoryId(_ categoryId: Int) async throws -> [ProductResponse] {
    // Build resource using dynamic category ID
    let resource = Resource(
      url: Constants.Urls.getProductsByCategoryId(categoryId),
      modelType: [ProductResponse].self
    )

    // Perform GET request and return results
    return try await httpClient.load(resource)
  }

  /// Adds a new product to the store under a specific category.
  /// - Parameters:
  ///   - title: Product title.
  ///   - price: Product price.
  ///   - description: Product description.
  ///   - categoryId: The ID of the category the product belongs to.
  ///   - images: Array of image URLs for the product.
  /// - Returns: The created `ProductResponse` from the API.
  func addProduct(
    title: String,
    price: Double,
    description: String,
    categoryId: Int,
    images: [URL]
  ) async throws -> ProductResponse {
    // Construct request model
    let addProductRequest = AddProductRequest(
      title: title,
      price: price,
      description: description,
      categoryId: categoryId,
      images: images
    )

    // Define POST resource
    let resource = Resource(
      url: Constants.Urls.addProduct,
      method: .post(try addProductRequest.encode()),
      modelType: ProductResponse.self
    )

    // Execute network request and return decoded response
    let addedProduct = try await httpClient.load(resource)
    return addedProduct
  }

  /// Deletes a product from the store by its ID.
  /// - Parameter productId: The ID of the product to delete.
  /// - Returns: A boolean indicating whether deletion succeeded.
  func deleteProduct(_ productId: Int) async throws -> Bool {
    // Define DELETE resource
    let resource = Resource(
      url: Constants.Urls.deleteProduct(productId),
      method: .delete,
      modelType: Bool.self
    )

    // Execute DELETE request
    let result = try await httpClient.load(resource)
    return result
  }

  // MARK: - Locations

  /// Loads all available store locations and updates `locations`.
  func loadLocations() async throws {
    // Define GET resource for locations
    let resource = Resource(
      url: Constants.Urls.locations,
      modelType: [LocationResponse].self
    )

    // Perform network call and assign to published list
    locations = try await httpClient.load(resource)
  }
}

