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
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    
    /*
//    func getAllProducts() async throws {
//        self.products = try await ProductsManager.shared.getAllProducts(priceDescending: nil, forCategory: nil)
//    }
     */
    
    func filterSelected(option: FilterOption) async throws {
        self.selectedFilter = option
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
            self.products = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDecending, forCategory: selectedCategory?.categoryKey)

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

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "None")") {
                    ForEach(ProductsViewModel.FilterOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await viewModel.filterSelected(option: option)
                            }
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "None")") {
                    ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await viewModel.categorySelected(option: option)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.getProducts()
        }
        .navigationTitle("Products")
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
