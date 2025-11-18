//
//  CreateUserResponse.swift
//  Platzi
//
//  Created by Brian Simmons on 10/24/25.
//

import Foundation

/*
 https://fakeapi.platzi.com/en/rest/users/#create-a-user
 
 CreateUserResponse example:
 {
 "email": "nico@gmail.com",
 "password": "1234",
 "name": "Nicolas",
 "avatar": "https://i.imgur.com/yhW6Yw1.jpg",
 "role": "customer",
 "id": 24
 }
 */
struct CreateUserResponse: Decodable, Encodable {
  let email: String
  let password: String
  let name: String
  let avatar: URL
  let role: String
  let id: Int
}
