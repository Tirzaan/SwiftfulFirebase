//
//  UserManager.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/8/25.
//

import Foundation
import FirebaseFirestore
internal import FirebaseSharedSwift

struct Movie: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}

struct databaseUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let favoriteMovie: Movie?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoUrl = auth.photoURL
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.favoriteMovie = nil
    }
    
    init(userId: String, isAnonymous: Bool? = nil, email: String? = nil, photoUrl: String? = nil, dateCreated: Date? = nil, isPremium: Bool? = nil, preferences: [String]? = nil, favoriteMovie: Movie? = nil) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.favoriteMovie = favoriteMovie
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "user_ispremium"
        case preferences = "preferences"
        case favoriteMovie = "favorite_movie"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favoriteMovie = try container.decodeIfPresent(Movie.self, forKey: .favoriteMovie)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favoriteMovie, forKey: .favoriteMovie)
    }
    
    // OLD CODE
    /*
    func togglePremiumStatus() -> databaseUser {
        let CurrentValue: Bool = isPremium ?? false
        return databaseUser(
            userId: userId,
            isAnonymous: isAnonymous,
            email: email,
            photoUrl: photoUrl,
            dateCreated: dateCreated,
            isPremium: !CurrentValue)

    }
    
    mutating func togglePremiumStatus() {
        let CurrentValue: Bool = isPremium ?? false
        isPremium = !CurrentValue
    }
    */
}

final class UserManager {
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func createNewUser(user: databaseUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> databaseUser {
        try await userDocument(userId: userId).getDocument(as: databaseUser.self)
    }
    
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [AnyHashable:Any] = [
            databaseUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addUserPreferences(userId: String, preference: String) async throws {
        let data: [AnyHashable:Any] = [
            databaseUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeUserPreferences(userId: String, preference: String) async throws {
        let data: [AnyHashable:Any] = [
            databaseUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addFavoriteMovie(userId: String, movie: Movie) async throws {
        guard let data = try? encoder.encode(movie) else { throw URLError(.badURL) }
        let dictionary: [AnyHashable:Any] = [
            databaseUser.CodingKeys.favoriteMovie.rawValue : data
        ]
        
        try await userDocument(userId: userId).updateData(dictionary)
    }
    
    func removeFavoriteMovie(userId: String) async throws {
        let data: [AnyHashable:Any?] = [
            databaseUser.CodingKeys.favoriteMovie.rawValue : nil
        ]
        
        try await userDocument(userId: userId).updateData(data as [AnyHashable : Any])
    }
}


// MARK: OLD CODE
/*
 CREATE NEW USER:
 func createNewUser(auth: AuthDataResultModel) async throws {
     var userData: [String:Any ] = [
         "user_id" : auth.uid,
         "is_anonymous" : auth.isAnonymous,
         "date_created" : Timestamp()
     ]
     if let email = auth.email {
         userData["email"] = email
     }
     if let photoURL = auth.photoURL {
         userData["photo_url"] = photoURL
     }
       
     try await userDocument(userId: auth.uid).setData(userData, merge: false)
 }
 
 GET USER:
 func getUser(userId: String) async throws -> databaseUser {
     let snapshot = try await userDocument(userId: userId).getDocument()
     
     guard let data = snapshot.data(), let userId = data["user_id"] as? String else { throw URLError(.badServerResponse) }
     
     let isAnonymous = data["is_anonymous"] as? Bool
     let email = data["email"] as? String
     let photoUrl = data["photo_url"] as? String
     let dateCreated = data["date_created"] as? Date
     
     return databaseUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
 }

 ENCODE AND DECODE
 private let encoder: Firestore.Encoder = {
     let encoder = Firestore.Encoder()
     encoder.keyEncodingStrategy = .convertToSnakeCase
     return encoder
 }()
 
 private let decoder: Firestore.Decoder = {
     let decoder = Firestore.Decoder()
     decoder.keyDecodingStrategy = .convertFromSnakeCase
     return decoder
 }()
 
 UPDATE PREMIUM
 func updateUserPremiumStatus(user: databaseUser) async throws {
     try userDocument(userId: user.userId).setData(from: user, merge: true)
 }
 
 */

