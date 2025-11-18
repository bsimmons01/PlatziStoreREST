//
//  AboutCardView.swift
//  Platzi
//
//  Created by Brian Simmons on 11/18/25.
//
import SwiftUI

struct AboutCardView<Content: View>: View {
  let content: Content
  init(@ViewBuilder content: () -> Content) { self.content = content() }

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      content
    }
    .padding(16)
    .background(.background.opacity(0.6), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    .overlay(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .strokeBorder(.separator.opacity(0.4))
    )
  }
}

struct SectionHeaderView: View {
  let text: String
  init(_ text: String) { self.text = text }
  var body: some View {
    Text(text)
      .font(.headline)
      .textCase(nil)
  }
}

struct LinkRowView: View {
  let title: String
  let subtitle: String
  let systemImage: String
  let url: () -> URL

  var body: some View {
    Link(destination: url()) {
      HStack(spacing: 12) {
        Image(systemName: systemImage)
          .imageScale(.large)
          .frame(width: 28)
          .accessibilityHidden(true)

        VStack(alignment: .leading, spacing: 2) {
          Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.primary)
          Text(subtitle)
            .font(.caption)
            .foregroundStyle(.secondary)
            .lineLimit(1)
        }

        Spacer()
        Image(systemName: "arrow.up.right")
          .imageScale(.small)
          .foregroundStyle(.secondary)
          .accessibilityHidden(true)
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}
