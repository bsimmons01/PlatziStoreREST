//
//  LocationDetailScreen.swift
//  Platzi
//
//  Created by Brian Simmons on 10/9/25.
//

import SwiftUI
import MapKit

struct LocationDetailScreen: View {
  let location: LocationResponse

  @State private var cameraPosition: MapCameraPosition

  init(location: LocationResponse) {
    self.location = location
    let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    cameraPosition = MapCameraPosition.region(region)
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(location.name)
        .font(.largeTitle)
      Text(location.description)
        .font(.title3)
      Map(position: $cameraPosition) {
        Marker(location.name, coordinate: location.coordinate)
      }
      .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    .padding()
  }
}

#Preview {
  LocationDetailScreen(location: LocationResponse(id: 1, name: "Fenway Park", description: "Where the Red Sox play their home baseball games", latitude: 42.3467, longitude: -71.0972))
}
