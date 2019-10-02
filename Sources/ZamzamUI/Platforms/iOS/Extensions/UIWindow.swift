//
//  UIWindow.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2017-11-20.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIWindow {
    
    /// The view controller associated with the currently visible view in the window interface.
    ///
    /// The currently visible view can belong to:
    /// * the view controller at the top of the navigation stack
    /// * the view controller that is selected in a tab bar controller
    /// * the view controller that was presented modally
    /// * the root view controller of the window
    var visibleViewController: UIViewController? {
        return getVisibleViewController(from: rootViewController)
    }
    
    /// Recursively retrieve the most visible view controller
    private func getVisibleViewController(from controller: UIViewController?) -> UIViewController? {
        /// https://stackoverflow.com/a/39857342
        if let nav = controller as? UINavigationController {
            return getVisibleViewController(from: nav.visibleViewController)
        } else if let tab = controller as? UITabBarController, let selected = tab.selectedViewController {
            return getVisibleViewController(from: selected)
        } else if let presented = controller?.presentedViewController {
            return getVisibleViewController(from: presented)
        }
        
        return controller
    }
}

public extension UIWindow {
    
    /// The view controller at the top of the window interface.
    ///
    /// The currently top view can belong to:
    /// * the view controller at the top of the navigation stack
    /// * the view controller that is selected in a tab bar controller
    /// * the view controller that is detail in a split view controller
    /// * the root view controller of the window
    var topViewController: UIViewController? {
        return getTopViewController(from: rootViewController)
    }
    
    /// Recursively retrieve the most top view controller
    private func getTopViewController(from controller: UIViewController?) -> UIViewController? {
        if let nav = controller as? UINavigationController {
            return getTopViewController(from: nav.topViewController)
        } else if let tab = controller as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(from: selected)
        } else if let split = controller as? UISplitViewController, let detail = split.viewControllers.last {
            return getTopViewController(from: detail)
        }
        
        return controller
    }
}

public extension UIWindow {
    
    /// Assign a view controller to root view controller for the window.
    ///
    /// Using this method provides more safety than assigning the root
    /// controller directly, such as dismissing all view controllers
    /// before setting. These steps ensure that view controllers are
    /// not retained in the background as zombies.
    ///
    /// - Parameter viewController: The view controller to assign as the root view controller.
    func setRootViewController(to viewController: UIViewController) {
        // https://github.com/onmyway133/notes/issues/251
        guard rootViewController?.presentedViewController == nil else {
            rootViewController?.dismiss(animated: false) {
                self.rootViewController = viewController
            }
            
            return
        }
        
        rootViewController = viewController
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
#endif
