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
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    
    func signInWithApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.SignInWithApple(tokens: tokens)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    
    func signInAnonymously() async throws {
        let authDataResult = try await AuthenticationManager.shared.SignInAnonymously()
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}
