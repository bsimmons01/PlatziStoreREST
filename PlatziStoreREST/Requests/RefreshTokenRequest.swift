//
//  RefreshTokenRequest.swift
//  Platzi
//
//  Created by Brian Simmons on 10/24/25.
//

import Foundation

/*
 https://fakeapi.platzi.com/en/rest/auth-jwt/#request-2
 
 RefreshTokenRequest example:
 {
 "email": "john@mail.com",
 "password": "changeme"
 }
 */

struct RefreshTokenRequest: Encodable {
  let refreshToken: String
}
