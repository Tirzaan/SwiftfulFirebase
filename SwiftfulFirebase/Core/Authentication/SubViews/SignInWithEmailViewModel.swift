//
//  SignInWithEmailViewModel.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/8/25.
//

import Foundation
import Combine

@MainActor
final class SignInWithEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
    func EmailPasswordNotEmpty() -> Bool {
        return !email.isEmpty || email == "" && !password.isEmpty || password == ""
    }
}
