//
//  AnalyticsView.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/20/25.
//

import SwiftUI
import FirebaseAnalytics

@MainActor
final class AnalyticsManager {
    static var shared = AnalyticsManager()
    private init() { }
    
    func logEvent(name: String, parameters: [String : Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }
    
    func setUserId(UserId: String) {
        Analytics.setUserID(UserId)
    }
    
    func SetUserProperty(value: String?, property: String) {
        Analytics.setUserProperty(value, forName: property)
    }
}

struct AnalyticsView: View {
    var body: some View {
        VStack(spacing: 40) {
            Button("Log Event") {
                AnalyticsManager.shared.logEvent(name: "AnalyticsView_LogEvent_ButtonClick")
            }
            
            Button("Log Second Event") {
                AnalyticsManager.shared.logEvent(name: "AnalyticsView_LogSecondEvent_ButtonClick", parameters: [
                    "screen_title" : "Hello, world!"
                ])
            }
        }
        .analyticsScreen(name: "AnalyticsView")
        .onAppear {
            AnalyticsManager.shared.logEvent(name: "AnalyticsView_Appear")
            
            AnalyticsManager.shared.setUserId(UserId: "ABC123")
            AnalyticsManager.shared.SetUserProperty(value: true.description.uppercased(), property: "user_is_premium")
        }
        .onDisappear {
            AnalyticsManager.shared.logEvent(name: "AnalyticsView_Disappear")
        }
    }
}

#Preview {
    AnalyticsView()
}
