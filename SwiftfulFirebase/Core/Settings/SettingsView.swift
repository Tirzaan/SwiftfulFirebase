//
//  SettingsView.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 9/22/25.
//

import SwiftUI

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

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}
