//
//  FavoritesView.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/16/25.
//

import SwiftUI
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    
    func getFavorites() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.userFavoriteProducts = try await UserManager.shared.getUserFavoriteProducts(userId: authDataResult.uid)
        }
    }
    
    func removeFromFavorites(favoriteProductId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, favoriteProductId: favoriteProductId)
            getFavorites()
        }
    }
}

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
        .onAppear {
            viewModel.getFavorites()
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
