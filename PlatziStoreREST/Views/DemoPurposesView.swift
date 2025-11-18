//
//  DemoPurposesView.swift
//  Platzi
//
//  Created by Brian Simmons on 11/17/25.
//

import SwiftUI

struct DemoPurposesView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(alignment: .top) {
        Image(systemName: "info.square")
        Text("For demonstration purposes, use a fake email address, such as jane@doe.com")
          .font(.subheadline)
          .multilineTextAlignment(.leading)
      }

      HStack(alignment: .top) {
        Image(systemName: "info.square")
        Text("Do not use a real password — Platzi stores passwords in plain text. Use something simple like Test1234")
          .font(.subheadline)
          .multilineTextAlignment(.leading)
      }
    }
    .padding()
    .background(Color.gray.opacity(0.05))
    .cornerRadius(8)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  DemoPurposesView()
}
