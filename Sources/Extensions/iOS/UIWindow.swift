//
//  UIWindow.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2017-11-20.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit

public extension UIWindow {
    
    /// Recursively retrieve the top most view controller
    /// https://stackoverflow.com/a/39857342/235334
    private func getTopViewController(from controller: UIViewController?) -> UIViewController? {
        if let nav = controller as? UINavigationController {
            return getTopViewController(from: nav.visibleViewController)
        } else if let tab = controller as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(from: selected)
        } else if let presented = controller?.presentedViewController {
            return getTopViewController(from: presented)
        }
        
        return controller
    }
    
    /// The top view controller for the window.
    var topViewController: UIViewController? {
        return getTopViewController(from: rootViewController)
    }
}
