//
//  ProductCellViewBuilder.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/17/25.
//

import SwiftUI

struct ProductCellViewBuilder: View {
    let productId: String
    @State private var product: Product? = nil
    
    var body: some View {
        ZStack {
            if let product {
                ProductCellView(product: product)
            } else {
                ProductCellView(product: Product(id: 0, title: "", description: "", price: 0, discountPercentage: 0, rating: 0, stock: 0, brand: "", category: "", thumbnail: "", images: []))
            }
        }
        .task {
            self.product = try? await ProductsManager.shared.getProduct(productId: productId)
        }
    }
}

#Preview {
    ProductCellViewBuilder(productId: "28")
}
