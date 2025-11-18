//
//  PlatziHeaderTextView.swift
//  Platzi
//
//  Created by Brian Simmons on 11/17/25.
//

import SwiftUI

struct PlatziHeaderTextView: View {
  let headerText: String

  var body: some View {
    HStack {
      Spacer()
      Text(headerText)
        .font(.title2.bold())
        .foregroundStyle(.blue)
      Spacer()
    }
  }
}

#Preview {
  PlatziHeaderTextView(headerText: "Platzi Login")
}
