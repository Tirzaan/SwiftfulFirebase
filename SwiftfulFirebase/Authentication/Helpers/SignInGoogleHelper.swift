//
//  SignInGoogleHelper.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 9/25/25.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
    
    init(idToken: String, accessToken: String, name: String?, email: String?) {
        self.idToken = idToken
        self.accessToken = accessToken
        self.name = name
        self.email = email
    }
}

final class SignInGoogleHelper {
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utilities.shared.topViewController() else {
            print("topVC ERROR")
            throw URLError(.cannotFindHost)
        }
        
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken: String = signInResult.user.idToken?.tokenString else {
            print("idToken ERROR")
            throw URLError(.badServerResponse)
        }
        let accessToken: String = signInResult.user.accessToken.tokenString
        let name = signInResult.user.profile?.name
        let email = signInResult.user.profile?.email
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
        return tokens
    }
}
