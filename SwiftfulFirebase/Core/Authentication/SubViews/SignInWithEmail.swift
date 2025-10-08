//
//  SignInWithEmail.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 9/20/25.
//

import SwiftUI

struct SignInWithEmail: View {
    @StateObject private var viewModel = SignInWithEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(viewModel.email == "" || viewModel.password == "" ? .gray : .blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(viewModel.email == "" || viewModel.password == "")
            
            Spacer()
        }
        .padding()
        
        .navigationTitle("Sign In With Email")
    }
}

#Preview {
    NavigationStack {
        SignInWithEmail(showSignInView: .constant(false))
    }
}
