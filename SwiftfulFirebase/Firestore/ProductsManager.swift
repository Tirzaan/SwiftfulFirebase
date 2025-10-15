//
//  ProductsManager.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/13/25.
//

import Foundation
import Firebase
import FirebaseFirestore

final class ProductsManager {
    static let shared = ProductsManager()
    private init() { }
    
    private let productsCollection = Firestore.firestore().collection("products")
    
    private func productsDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    func uploadProduct(product: Product) async throws {
        try productsDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productsDocument(productId: productId).getDocument(as: Product.self)
    }
    
    func getAllProducts() async throws -> [Product] {
        try await productsCollection.getDocuments(as: Product.self)
    }
}

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        return try snapshot.documents.map { try $0.data(as: T.self) }
    }
}
