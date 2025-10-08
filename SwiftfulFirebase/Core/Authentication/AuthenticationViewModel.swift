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
        try await AuthenticationManager.shared.SignInWithGoogle(tokens: tokens)
    }
    
    func signInWithApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthenticationManager.shared.SignInWithApple(tokens: tokens)
    }
    
    func signInAnonymously() async throws {
        try await AuthenticationManager.shared.SignInAnonymously()
    }
}
