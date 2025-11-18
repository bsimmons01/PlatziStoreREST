//
//  ProductResponse.swift
//  Platzi
//
//  Created by Brian Simmons on 10/24/25.
//

import Foundation

/*
 https://fakeapi.platzi.com/en/rest/products/#get-a-single-product-by-id
 
 {
 "id": 4,
 "title": "Handmade Fresh Table",
 "slug": "handmade-fresh-table",
 "price": 687,
 "description": "Andy shoes are designed to keeping in...",
 "category": {
 "id": 1,
 "name": "Others",
 "slug": "others",
 "image": "https://placehold.co/600x400"
 },
 "images": [
 "https://placehold.co/600x400",
 "https://placehold.co/600x400",
 "https://placehold.co/600x400"
 ]
 }
 */

struct ProductResponse: Identifiable, Codable {
  let id: Int
  let title: String
  let slug: String
  let price: Double
  let description: String
  let images: [URL]
}

extension ProductResponse {
  static var preview: ProductResponse {
    ProductResponse(id: 1,
                    title: "Baseball Cap",
                    slug: "ballcap",
                    price: 4.33,
                    description: "Some ballcap lorem ipsum et dolor sit amet consectetur adipisicing elit.",
                    images: [URL.randomProductImageURL])
  }
}
