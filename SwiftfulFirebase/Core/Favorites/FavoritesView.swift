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
    private var cancelables: Set<AnyCancellable> = []
    
    func addListenerForFavorites() {
        guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else { return }
        UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid)
            .sink { completion in
                
            } receiveValue: { [weak self] products in
                self?.userFavoriteProducts = products
            }
            .store(in: &cancelables)

        /*
//        UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid) { [weak self] products in
//            self?.userFavoriteProducts = products
//        }
         */
    }
    
    /*
//    func getFavorites() {
//        Task {
//            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//            self.userFavoriteProducts = try await UserManager.shared.getUserFavoriteProducts(userId: authDataResult.uid)
//        }
//    }
     */
    
    func removeFromFavorites(favoriteProductId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, favoriteProductId: favoriteProductId)
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
        .onFirstAppear {
            viewModel.addListenerForFavorites()
        }
        .navigationTitle("Favorites")
    }
}

struct OnFirstAppearViewModifier: ViewModifier {
    @State private var didAppear: Bool = false
    let perform: (() -> ())?

    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didAppear {
                    perform?()
                    didAppear = true
                }
            }
    }
}

extension View {
    func onFirstAppear(perform: (() -> ())?) -> some View {
        modifier(OnFirstAppearViewModifier(perform: perform))
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
