//
//  PlatziHeaderImage.swift
//  Platzi
//
//  Created by Brian Simmons on 11/17/25.
//

import SwiftUI

struct PlatziHeaderImageView: View {
    var body: some View {
      Image("AppIcon1024")
        .resizable()
        .scaledToFit()
        .frame(width: 150)
        .cornerRadius(30)
        .padding(.top, 15)
        .shadow(color: .black.opacity(0.8), radius: 10, x: 5, y: 5)
    }
}

#Preview {
    PlatziHeaderImageView()
}
