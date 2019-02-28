//
//  UIWindow.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2017-11-20.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit

public extension UIWindow {
    
    /// The top view controller for the window.
    var topViewController: UIViewController? {
        return getTopViewController(from: rootViewController)
    }
    
    /// Recursively retrieve the top most view controller
    private func getTopViewController(from controller: UIViewController?) -> UIViewController? {
        /// https://stackoverflow.com/a/39857342
        if let nav = controller as? UINavigationController {
            return getTopViewController(from: nav.visibleViewController)
        } else if let tab = controller as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(from: selected)
        } else if let presented = controller?.presentedViewController {
            return getTopViewController(from: presented)
        }
        
        return controller
    }
}

public extension UIWindow {
    
    /// Unload all views and add back.
    ///
    /// Useful for applying `UIAppearance` changes to existing views.
    func reload() {
        subviews.forEach { view in
            view.removeFromSuperview()
            addSubview(view)
        }
    }
}

public extension Array where Element == UIWindow {
    
    /// Unload all views for each `UIWindow` and add back.
    ///
    /// Useful for applying `UIAppearance` changes to existing views.
    func reload() {
        forEach { $0.reload() }
    }
}
