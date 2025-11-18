//
//  LocationListScreen.swift
//  Platzi
//
//  Created by Brian Simmons on 10/9/25.
//

import SwiftUI
import MapKit

struct LocationListScreen: View {
  @Environment(PlatziStore.self) private var store

  @State private var isLoading = true
  @State private var cameraPosition = MapCameraPosition.region(.fenwayParkRegion)
  @State private var selectedLocation: LocationResponse?

  var body: some View {
    Map(position: $cameraPosition) {
      ForEach(store.locations) { location in
        Annotation(location.name, coordinate: location.coordinate) {
          Image(systemName: "mappin.circle.fill")
            .foregroundStyle(selectedLocation?.id == location.id ? .green : .brown)
            .font(selectedLocation?.id == location.id ? .largeTitle : .title3)
            .scaleEffect(selectedLocation?.id == location.id ? 1.5 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedLocation?.id)
            .onTapGesture {
              selectedLocation = location
            }
        }
      }
    }
    .navigationTitle("Locations")
    .navigationBarTitleDisplayMode(.inline)
    .sheet(item: $selectedLocation, content: { location in
      LocationDetailScreen(location: location)
        .presentationDetents([.medium])
    })
    .task {
      await loadLocations()
    }
  }

  private func loadLocations() async {
    defer {
      isLoading = false
    }
    do {
      isLoading = true
      try await store.loadLocations()

      let coordinates = store.locations.map { $0.coordinate }

      if let region = regionThatFits(coordinates) {
        cameraPosition = .region(region)
      }
    } catch {
      print("🗺️ Error fetching locations: \(error.localizedDescription)")
    }
  }

  private func regionThatFits(_ coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion? {
    guard !coordinates.isEmpty else { return nil }

    let mapRect = coordinates.reduce(MKMapRect.null) { rect, coord in
      let point = MKMapPoint(coord)
      let pointRect = MKMapRect(origin: point, size: MKMapSize(width: 0, height: 0))
      return rect.union(pointRect)
    }
    return MKCoordinateRegion(mapRect)
  }
}

#Preview {
  NavigationStack {
    LocationListScreen()
  }
  .environment(PlatziStore(httpClient: HTTPClient()))
}
