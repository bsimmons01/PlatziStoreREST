//
//  CategoryResponse.swift
//  Platzi
//
//  Created by Brian Simmons on 10/24/25.
//

import Foundation

/*
 https://fakeapi.platzi.com/en/rest/categories/#get-a-single-category-by-id
 
 {
 "id": 1,
 "name": "Clothes",
 "slug": "clothes",
 "image": "https://placehold.co/600x400"
 }
 */

struct CategoryResponse: Identifiable, Decodable, Encodable {
  let id: Int
  let name: String
  let slug: String
  let image: URL
}

extension CategoryResponse {
  static var preview: CategoryResponse {
    CategoryResponse(id: 1,
                     name: "Clothes",
                     slug: "clothes",
                     image: URL(string: "https://placehold.co/600x400")!)
  }
}

