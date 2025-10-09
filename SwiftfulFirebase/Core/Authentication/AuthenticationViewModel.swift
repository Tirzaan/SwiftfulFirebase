//
//  AuthenticationViewModel.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/8/25.
//

import Foundation
import Combine

@MainActor
final class AuthenticationViewModel: ObservableObject {
    let appleHelper = SignInAppleHelper()
    
    func signInWithGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.SignInWithGoogle(tokens: tokens)
        let user = databaseUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInWithApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.SignInWithApple(tokens: tokens)
        let user = databaseUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInAnonymously() async throws {
        let authDataResult = try await AuthenticationManager.shared.SignInAnonymously()
        let user = databaseUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
//        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}
