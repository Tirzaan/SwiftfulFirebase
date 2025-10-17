//
//  ProductsViewModel.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/17/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import Combine

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    private var lastDocument: DocumentSnapshot? = nil
    
    /*
//    func getAllProducts() async throws {
//        self.products = try await ProductsManager.shared.getAllProducts(priceDescending: nil, forCategory: nil)
//    }
     */
    
    func filterSelected(option: FilterOption) async throws {
        self.selectedFilter = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()
        
        /*
//        switch option {
//        case .noFilter:
//            try await getAllProducts()
//        case .priceHigh:
//            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: true)
//        case .priceLow:
//            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: false)
//        }
            */
        
    }
    
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()
        /*
//        switch option {
//        case .noCategory:
//            try await getAllProducts()
//        case .groceries, .beauty, .fragrances, .furniture:
//            self.products = try await ProductsManager.shared.getAllProductsForCategory(category: option.rawValue)
//
//
//        }
         */
    }
    
    func getProducts() {
        Task {
            let (newProducts, lastDocument) = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDecending, forCategory: selectedCategory?.categoryKey, count: 10, lastDocument: lastDocument)
            self.products.append(contentsOf: newProducts)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
    
    func getProductsByRating() {
        Task {
//            let newProducts = try await ProductsManager.shared.getProductsByRating(count: 3, lastRating: self.products.last?.rating)
            
            let (newProducts, lastDocument) = try await ProductsManager.shared.getProductsByRating(count: 3, lastDocument: lastDocument)
            self.products.append(contentsOf: newProducts)
            self.lastDocument = lastDocument
        }
    }
    
    func getProductsCount() {
        Task {
            let count = try await ProductsManager.shared.getAllProductsCount()
            print("All Products Count: \(count)")
        }
    }
    
    func addUserFavoriteProduct(productId: Int) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserFavoriteProduct(userId: authDataResult.uid, productId: productId)
        }
    }
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDecending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case groceries
        case beauty
        case fragrances
        case furniture
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            } else {
                return self.rawValue
            }
        }
    }
}
