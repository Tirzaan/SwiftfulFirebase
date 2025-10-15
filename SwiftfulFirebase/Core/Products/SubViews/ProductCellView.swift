//
//  ProductCellView.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/13/25.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProductsView()
            }
            .frame(width: 75, height: 75)
            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)

            
            VStack(alignment: .leading) {
                Text(product.title ?? "N/A")
                    .foregroundStyle(.primary)
                    .font(.headline)
                Text("Price: $" + String(product.price ?? 0))
                    .foregroundStyle(.secondary)
                Text("Rating: ⭐️" + String(product.rating ?? 0))
                    .foregroundStyle(.secondary)
                Text("Category: " + (product.category ?? "N/A"))
                    .foregroundStyle(.secondary)
                Text("Brand: " + (product.brand ?? "N/A"))
                    .foregroundStyle(.secondary)
            }
            .font(.callout)
        }
    }
}

#Preview {
    ProductCellView(product: Product(id: 0, title: "Title", description: "Description", price: 10, discountPercentage: 50, rating: 3.4, stock: 5, brand: "Brand", category: "Category", thumbnail: "https://dummyjson.com/image/150", images: []))
}
