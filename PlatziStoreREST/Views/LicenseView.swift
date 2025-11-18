//
//  LicenseView.swift
//  Platzi
//
//  Created by Brian Simmons on 11/18/25.
//

import SwiftUI

struct LicenseView: View {
    var body: some View {
      AboutCardView {
        VStack(alignment: .leading, spacing: 12) {
          SectionHeaderView("About This App")

          Text(
            "All code written by Brian Simmons, unless otherwise notated, and released under the MIT License. Attribution is required."
          )
          .fixedSize(horizontal: false, vertical: true)

          LinkRowView(
            title: "MIT License",
            subtitle: "opensource.org/license/mit",
            systemImage: "doc.text"
          ) {
            URL(string: "https://opensource.org/license/mit")!
          }
        }
      }

      // APIs & Libraries
      AboutCardView {
        VStack(alignment: .leading, spacing: 12) {
          SectionHeaderView("APIs")

          LinkRowView(
            title: "Platzi Fake Store API",
            subtitle: "For your e-commerce/shopping prototype",
            systemImage: "server.rack"
          ) {
            URL(string: "https://fakeapi.platzi.com/en")!
          }
        }
      }

      AboutCardView {
        VStack(alignment: .leading, spacing: 12) {
          SectionHeaderView("Brian's Apps in the App Store")

          LinkRowView(
            title: "Heard It All",
            subtitle: "Relive every Billboard Hot 100 #1",
            systemImage: "music.note"
          ) {
            URL(string: "https://apps.apple.com/app/id6746056385")!
          }

          LinkRowView(
            title: "What Year Was It?",
            subtitle: "Challenge your memory across history",
            systemImage: "gamecontroller"
          ) {
            URL(string: "https://apps.apple.com/app/id6745128395")!
          }
        }
      }

      CourseCreditCardView()
    }
}

#Preview {
    LicenseView()
}
