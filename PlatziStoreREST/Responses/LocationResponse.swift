//
//  LocationResponse.swift
//  Platzi
//
//  Created by Brian Simmons on 10/24/25.
//

import Foundation
import MapKit

/*
 https://fakeapi.platzi.com/en/rest/locations/#get-all-locations
 
 LocationResponse example:
 {
 "id": 3456024234637667,
 "name": "2063 Bath Street",
 "description": "Urbanus illum aspernatur.",
 "latitude": 4.647499671477389,
 "longitude": -74.27320830941972
 }
 */
struct LocationResponse: Identifiable, Codable {
  let id: Int
  let name: String
  let description: String
  let latitude: Double
  let longitude: Double

  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}
