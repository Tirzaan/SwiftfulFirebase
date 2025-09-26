//
//  Utilities.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 9/23/25.
//

import Foundation
import UIKit

final class Utilities {
    static let shared = Utilities()
    private init() {}
    
    /// Recursively finds the top-most view controller starting from the provided controller
    /// (or from the root of the current key window if none is provided).
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
