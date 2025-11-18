//
//  MKCoordinateRegion+Extensions.swift
//  Platzi
//
//  Created by Brian Simmons on 10/9/25.
//

import Foundation
import MapKit

// MARK: - MKCoordinateRegion Extension
// Adds a convenience property for a preconfigured map region centered on Fenway Park.
// This can be useful for initializing a Map view with a known default location.

extension MKCoordinateRegion {
  // Coordinates for Fenway Park in Boston, Massachusetts:
  // Latitude:  42.3467° N
  // Longitude: 71.0972° W

  /// A static computed property that returns an `MKCoordinateRegion`
  /// centered on Fenway Park with a small zoom level (tight view).
  static var fenwayParkRegion: MKCoordinateRegion {
    MKCoordinateRegion(
      center: .init(latitude: 42.3467, longitude: -71.0972), // Center coordinate for Fenway Park
      span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01) // Small delta = zoomed-in region
    )
  }
}

