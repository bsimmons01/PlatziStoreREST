//
//  CreateUserRequest.swift
//  Platzi
//
//  Created by Brian Simmons on 10/24/25.
//

import Foundation

/*
 https://fakeapi.platzi.com/en/rest/users/#create-a-user

 CreateUserRequest example:
 {
 "name": "Nicolas",
 "email": "nico@gmail.com",
 "password": "1234",
 "avatar": "https://picsum.photos/800"
 }
 */

struct CreateUserRequest: Encodable {
  let name: String
  let email: String
  let password: String
  let avatar: URL
}
