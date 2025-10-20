//
//  CrashManager.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/20/25.
//

import Foundation
import FirebaseCrashlytics

@MainActor
final class CrashManager {
    static let shared = CrashManager()
    private init() { }
    
    func setUserId(userId: String) {
        Crashlytics.crashlytics().setUserID(userId)
    }
    
    private func setValue(value: String, key: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    
    func setIsPremium(isPremium: Bool) {
        setValue(value: isPremium.description.uppercased(), key: "user_is_premium")
    }
    
    func addLog(message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    func sendNonFatal(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}
