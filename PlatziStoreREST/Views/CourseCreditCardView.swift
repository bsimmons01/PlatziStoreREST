//
//  CourseCreditCardView.swift
//  Platzi
//
//  Created by Brian Simmons on 10/26/25.
//

import SwiftUI

struct CourseCreditCardView: View {
  @Environment(\.openURL) private var openURL

  // Customize these if you want to reuse
  var title: String = "Built with lessons from"
  var courseName: String = "The Complete Guide to Integrating JSON API with SwiftUI"
  var authorName: String = "Mohammad Azam"
  var courseURL: URL = URL(string: "https://www.udemy.com/course/the-complete-guide-to-integrating-json-api-with-swiftui/")!
  var showsDisclaimer: Bool = true

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 12) {
        Image(systemName: "link.badge.plus")
          .font(.system(size: 28, weight: .semibold))
          .imageScale(.large)
          .accessibilityHidden(true)
          .padding(10)
          .background(
            Circle()
              .fill(.ultraThinMaterial)
              .overlay(Circle().stroke(.white.opacity(0.25), lineWidth: 0.5))
          )

        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)

          // Main line with strong emphasis
          Text("“\(courseName)”")
            .font(.headline)
            .lineLimit(2)
            .minimumScaleFactor(0.85)

          Text("by \(authorName)")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }

        Spacer(minLength: 0)
      }

      // Action row
      HStack(spacing: 10) {
        Button {
          openURL(courseURL)
        } label: {
          Label("View Course", systemImage: "arrow.up.right.square")
            .font(.subheadline.weight(.semibold))
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(.ultraThinMaterial))
        }
        .buttonStyle(.plain)
        .accessibilityHint("Opens the course page in your browser")

        Spacer()

        // Optional Udemy mark (text-only to keep it simple)
        Text("Udemy")
          .font(.caption2)
          .padding(.vertical, 4)
          .padding(.horizontal, 8)
          .background(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(.white.opacity(0.35), lineWidth: 0.5))
          .opacity(0.8)
      }

      if showsDisclaimer {
        Divider().opacity(0.5)
        Text("Not affiliated with or endorsed by the instructor or Udemy")
          .font(.caption2)
          .foregroundStyle(.secondary)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
    .padding(16)
    .background(cardBackground)
    .overlay(
      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .strokeBorder(.white.opacity(0.15), lineWidth: 1)
    )
    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    .shadow(color: .black.opacity(0.25), radius: 18, x: 0, y: 8)
    .accessibilityElement(children: .combine)
  }

  private var cardBackground: some View {
    // Subtle gradient that adapts to light/dark
    LinearGradient(
      colors: [
        Color.accentColor.opacity(0.30),
        Color.accentColor.opacity(0.15)
      ],
      startPoint: .topLeading, endPoint: .bottomTrailing
    )
    //.overlay(.ultraThinMaterial)
  }
}

#Preview {
  VStack(spacing: 24) {
    CourseCreditCardView()
      .padding()
  }
  .background(Color(.systemBackground))
}
