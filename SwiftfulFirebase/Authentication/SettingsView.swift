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
    
    func loadAuthProviders() throws {
        try authProviders = AuthenticationManager.shared.getProviders()
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
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
            
            if viewModel.authProviders.contains(.email) {
                emailFunctions
            }
        }
        .onAppear {
            do {
                try viewModel.loadAuthProviders()
            } catch {
                print("AP ERROR: \(error)")
            }
            
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
}
