//
//  URL+Extensions.swift
//  Platzi
//
//  Created by Brian Simmons on 10/8/25.
//

import Foundation

// MARK: - URL Extension
// Adds a convenient static property for generating or referencing a placeholder image URL.
// Useful for mocking or providing default images in demos or previews.

extension URL {
  /// A static var returning a placeholder image URL.
  /// The `!` is safe here because the string is known to form a valid URL.
  /// Example usage:
  /// ```swift
  /// AsyncImage(url: .randomProductImageURL)
  /// ```

  /// Returns a random product image URL each time it's accessed.
  static var randomProductImageURL: URL {
    URL(string: "https://centrasoft.com/images/platzi/product/product\(Int.random(in: 1...8)).jpg")!
  }

  /// Returns a random product image URL array each time it's accessed.
  static var randomProductImageURLs: [URL] {
    let numbers = Array(1...8).shuffled().prefix(3)
    return numbers.map {
      URL(string: "https://centrasoft.com/images/platzi/product/product\($0).jpg")!
    }
  }

  /// Returns a random category image URL each time it's accessed.
  static var randomCategoryImageURL: URL {
    URL(string: "https://centrasoft.com/images/platzi/category/category\(Int.random(in: 1...8)).jpg")!
  }
}

