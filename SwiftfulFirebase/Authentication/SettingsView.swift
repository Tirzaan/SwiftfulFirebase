//
//  SettingsView.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 9/22/25.
//

import SwiftUI
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil

    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.deleteUser()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let newEmail = "hello123@gmail.com"
        try await AuthenticationManager.shared.updateEmail(newEmail: newEmail)
    }
    
    func updatePassword() async throws {
        let newPassword = "Hello123!"
        try await AuthenticationManager.shared.updatePassword(newPassword: newPassword)
    }
    
    func linkGoogleAcount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
    }
    
    func linkAppleAcount() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        self.authUser = try await AuthenticationManager.shared.linkApple(tokens: tokens)
    }
    
    func linkEmailAcount() async throws {
        let email = "hello123@gmail.com"
        let password = "Hello123!"
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
    }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log Out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print("LO ERROR: \(error)")
                    }
                }
            }
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        print("DA ERROR: \(error)")
                    }
                }
            } label: {
                Text("DELETE ACCOUNT")
            }
            
            if viewModel.authProviders.contains(.email) {
                emailFunctions
            }
            
            if viewModel.authUser?.isAnonymous == true {
                AnonymousFunctions
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}

extension SettingsView {
    private var emailFunctions: some View {
        Section {
            Button("Reset Password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password Reset Sent")
                    } catch {
                        print("RP ERROR: \(error)")
                    }
                }
            }
            
            Button("Update Email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("Email Updated")
                    } catch {
                        print("UE ERROR: \(error)")
                    }
                }
            }
            
            Button("Update Password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("Password Updated")
                    } catch {
                        print("UP ERROR: \(error)")
                    }
                }
            }
        } header: {
            Text("Email Functions")
        }
    }
    
    private var AnonymousFunctions: some View {
        Section {
            Button("Link Google Acount") {
                Task {
                    do {
                        try await viewModel.linkGoogleAcount()
                        print("Linked Google Acount")
                    } catch {
                        print("LGA ERROR: \(error)")
                    }
                }
            }
            
            Button("Link Apple Acount") {
                Task {
                    do {
                        try await viewModel.linkAppleAcount()
                        print("Linked Apple Acount")
                    } catch {
                        print("LAA ERROR: \(error)")
                    }
                }
            }
            
            Button("Link Email Acount") {
                Task {
                    do {
                        try await viewModel.linkEmailAcount()
                        print("Linked Email Acount")
                    } catch {
                        print("LEA ERROR: \(error)")
                    }
                }
            }
        } header: {
            Text("create Acount")
        }
    }
}
