//
//  AddProductRequest.swift
//  Platzi
//
//  Created by Brian Simmons on 10/24/25.
//

import Foundation

/*
 https://fakeapi.platzi.com/en/rest/products/#create-a-product
 
 Create a product example:
 {
 "title": "New Product",
 "price": 10,
 "description": "A description",
 "categoryId": 1,
 "images": ["https://placehold.co/600x400"]
 }
 */

struct AddProductRequest: Codable {
  let title: String
  let price: Double
  let description: String
  let categoryId: Int
  let images: [URL]
}
