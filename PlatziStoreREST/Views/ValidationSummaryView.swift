//
//  ValidationSummaryView.swift
//  Platzi
//
//  Created by Brian Simmons on 10/7/25.
//

import SwiftUI

struct ValidationSummaryView: View {
  let errors: [String]

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      ForEach(errors, id: \.self) { error in
        HStack(alignment: .top) {
          Image(systemName: "exclamationmark.triangle.fill")
            .foregroundStyle(.red)
          Text(error)
            .foregroundStyle(.red)
            .font(.subheadline)
            .multilineTextAlignment(.leading)
        }
      }
    }
    .padding()
    .background(Color.red.opacity(0.05))
    .cornerRadius(8)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  ValidationSummaryView(errors: [
    "Must be at least 8 characters",
    "Must include a number",
    "Must not contain spaces"
  ])
  .padding()
}
