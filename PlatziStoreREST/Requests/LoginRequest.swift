//
//  LoginRequest.swift
//  Platzi
//
//  Created by Brian Simmons on 10/24/25.
//

import Foundation

/*
 https://fakeapi.platzi.com/en/rest/auth-jwt/#request
 
 LoginRequest example:
 {
 "email": "john@mail.com",
 "password": "changeme"
 }
 */

struct LoginRequest: Encodable {
  let email: String
  let password: String
}
