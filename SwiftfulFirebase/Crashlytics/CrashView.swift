//
//  CrashView.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/20/25.
//

import SwiftUI

struct CrashView: View {
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            
            VStack {
                Button("Force Unwrapping") {
                    CrashManager.shared.addLog(message: "'Force Unwrapping' Button Pressed")
                    let myOptionalString: String? = nil
                    guard let myOptionalString else {
                        CrashManager.shared.sendNonFatal(error: URLError(.badServerResponse))
                        return
                    }
                    
                    let myString = myOptionalString
                }
                
                Button("Fatal Error") {
                    CrashManager.shared.addLog(message: "'Fatal Error' Button Pressed")
                   fatalError("Fatal Error Button Clicked")
                }
                
                Button("Array Index Out of Bounds") {
                    CrashManager.shared.addLog(message: "'Array Index Out of Bounds' Button Pressed")
                    let array: [String] = []
                    let item = array[0]
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            CrashManager.shared.setUserId(userId: "ABC123")
            CrashManager.shared.setIsPremium(isPremium: true)
            CrashManager.shared.addLog(message: "Crash View Appeared")
        }
    }
}

#Preview {
    CrashView()
}
