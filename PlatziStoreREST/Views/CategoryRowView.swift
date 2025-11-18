//
//  CategoryRowView.swift
//  Platzi
//
//  Created by Brian Simmons on 10/8/25.
//

import SwiftUI

struct CategoryRowView: View {
  let category: CategoryResponse

  var body: some View {
    HStack {
      AsyncImage(url: category.image) { img in
        img
          .resizable()
          .frame(width: 75, height: 75)
          .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
      } placeholder: {
        ImagePlaceholderView()
      }
      Text(category.name)
        .font(.title3)
    }
  }
}

#Preview {
  CategoryRowView(category: CategoryResponse(id: 1, name: "Shoes", slug: "shoes", image: URL.randomCategoryImageURL))
}
