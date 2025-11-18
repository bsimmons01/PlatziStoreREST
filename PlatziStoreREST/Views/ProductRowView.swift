//
//  ProductRowView.swift
//  Platzi
//
//  Created by Brian Simmons on 10/8/25.
//

import SwiftUI

struct ProductRowView: View {
  let product: ProductResponse

  var body: some View {
    HStack {
      AsyncImage(url: product.images.first) { img in
        img
          .resizable()
          .frame(width: 75, height: 75)
          .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
      } placeholder: {
        ImagePlaceholderView()
      }
      Text(product.title)
        .font(.title3)
    }
  }
}

#Preview {
  ProductRowView(product: ProductResponse.preview)
}
