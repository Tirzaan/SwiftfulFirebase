//
//  ProductsView.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/13/25.
//

import SwiftUI
import Combine

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    
    func getAllProducts() async throws {
        self.products = try await ProductsManager.shared.getAllProducts()
    }
}

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
            }
        }
        
        .task {
            try? await viewModel.getAllProducts()
        }
        .navigationTitle("Products")
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
