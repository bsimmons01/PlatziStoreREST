//
//  Constants.swift
//  Platzi
//
//  Created by Brian Simmons on 10/7/25.
//

import Foundation

struct Constants {
  struct Urls {
    static let users = URL(string: "https://api.escuelajs.co/api/v1/users/")!
    static let login = URL(string: "https://api.escuelajs.co/api/v1/auth/login")!
    static let refreshToken = URL(string: "https://api.escuelajs.co/api/v1/auth/refresh-token")!
    static let categories = URL(string:"https://api.escuelajs.co/api/v1/categories")!
    static let addCategory = URL(string:"https://api.escuelajs.co/api/v1/categories")!
    static let addProduct = URL(string:"https://api.escuelajs.co/api/v1/products/")!
    static let locations = URL(string:"https://api.escuelajs.co/api/v1/locations")!

    static func getProductsByCategoryId(_ id: Int) -> URL {
      URL(string: "https://api.escuelajs.co/api/v1/categories/\(id)/products")!
    }
    
    static func deleteProduct(_ id: Int) -> URL {
      URL(string: "https://api.escuelajs.co/api/v1/products/\(id)")!
    }
  }

  enum SettingsKeys {
    static let registeredEmail = "registeredEmail"
    static let registeredName = "registeredName"
  }
}
