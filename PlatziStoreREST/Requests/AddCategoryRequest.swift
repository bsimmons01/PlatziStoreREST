//
//  AddCategoryRequest.swift
//  Platzi
//
//  Created by Brian Simmons on 10/24/25.
//

import Foundation

/*
 https://fakeapi.platzi.com/en/rest/categories/#create-a-category

 Create a category example:
 {
 "name": "New Category",
 "image": "https://placeimg.com/640/480/any"
 }
 */

struct AddCategoryRequest: Encodable {
  let name: String
  let image: URL
}

