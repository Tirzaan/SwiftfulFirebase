//
//  FavoritesView.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/16/25.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        List {
            if viewModel.userFavoriteProducts.isEmpty {
                Text("No Favorites Yet!")
            } else {
                ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
                    ProductCellViewBuilder(productId: String(item.productId))
                        .contextMenu {
                            Button("remove from Favorites") {
                                viewModel.removeFromFavorites(favoriteProductId: item.id)
                            }
                        }
                }
            }
        }
        .onFirstAppear {
            viewModel.addListenerForFavorites()
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
