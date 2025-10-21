//
//  SwiftfulFirebaseApp.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 9/20/25.
//

import SwiftUI
import Firebase

@main
struct SwiftfulFirebaseApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AnalyticsView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
