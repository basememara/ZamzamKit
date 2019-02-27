//
//  Routable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/26/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//  http://basememara.com/protocol-oriented-router-in-swift/
//

import UIKit

/// Provides routing functionality for a type to remove navigation responsibility off `UIViewController`.
///
///     struct MyRouter: Router {
///         weak var viewController: UIViewController?
///
///         init(viewController: UIViewController?) {
///             self.viewController = viewController
///         }
///
///         func showSettings(date: Date) {
///             present(storyboard: "ShowSettings") { (controller: ShowSettingsViewController) in
///                 controller.someProperty = date
///             }
///         }
///     }
///
///     class MyViewController: UIViewController {
///
///         private lazy var router: Router = MyRouter(
///             viewController: self
///         )
///
///         @IBAction func settingsTapped() {
///             router.showSettings(date: Date())
///         }
///     }
///
/// Conforming types should use a weak `UIViewController` instance.
public protocol Router {
    var viewController: UIViewController? { get set }
    
    /// Presents a view controller from the specified storyboard modally.
    ///
    ///     present(storyboard: "ShowSettings") { (controller: ShowSettingsViewController) in
    ///         controller.someProperty = "Abc"
    ///     }
    ///
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    /// - Parameters:
    ///   - storyboard: Storyboard name.
    ///   - bundle: Bundle of the storyboard.
    ///   - identifier: Storyboard identifier.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - modalPresentationStyle: The presentation style for modally presented view controllers.
    ///   - modalTransitionStyle: The transition style to use when presenting the view controller.
    ///   - configure: Configure the view controller before it is loaded.
    ///   - completion: Completion the view controller after it is loaded.
    /// - Returns: Returns the view controller instance from the storyboard.
    @discardableResult
    func present<T: UIViewController>(
        storyboard: String,
        inBundle bundle: Bundle?,
        identifier: String?,
        animated: Bool,
        modalPresentationStyle: UIModalPresentationStyle?,
        modalTransitionStyle: UIModalTransitionStyle?,
        configure: ((T) -> Void)?,
        completion: ((T) -> Void)?) -> T?
    
    /// Present a view controller from the specified storyboard in the primary context.
    ///
    ///     show(storyboard: "ShowSettings") { (controller: ShowSettingsViewController) in
    ///         controller.someProperty = "Abc"
    ///     }
    ///
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    /// - Parameters:
    ///   - storyboard: Storyboard name.
    ///   - bundle: Bundle of the storyboard.
    ///   - identifier: Storyboard identifier.
    ///   - configure: Configure the view controller before it is loaded.
    /// - Returns: Returns the view controller instance from the storyboard.
    @discardableResult
    func show<T: UIViewController>(
        storyboard: String,
        inBundle bundle: Bundle?,
        identifier: String?,
        configure: ((T) -> Void)?) -> T?
    
    /// Present a view controller from the specified storyboard in the secondary (or detail) context.
    ///
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    /// - Parameters:
    ///   - storyboard: Storyboard name.
    ///   - bundle: Bundle of the storyboard.
    ///   - identifier: Storyboard identifier.
    ///   - configure: Configure the view controller before it is loaded.
    /// - Returns: Returns the view controller instance from the storyboard.
    @discardableResult
    func showDetailViewController<T: UIViewController>(
        storyboard: String,
        inBundle bundle: Bundle?,
        identifier: String?,
        configure: ((T) -> Void)?) -> T?
    
    /// Selects the tab for the root controller of the window.
    ///
    ///     show(tab: 3) { (controller: ShowSettingsViewController) in
    ///         controller.someProperty = "Abc"
    ///     }
    ///
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    /// - Parameters:
    ///   - tab: The tab to select.
    ///   - window: The window where the root tab controller resides.
    ///   - configure: Configure the view controller before it is loaded.
    ///   - completion: Completion the view controller after it is loaded.
    @discardableResult
    func show<T: UIViewController>(
        tab: Int,
        for window: UIWindow?,
        configure: ((T) -> Void)?,
        completion: ((T) -> Void)?) -> T?
    
    /// Swaps the root controller of the main window.
    ///
    ///     root(storyboard: "ShowDashboard") { (controller: ShowDashboardViewController) in
    ///         controller.someProperty = "Abc"
    ///     }
    ///
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    /// - Parameters:
    ///   - storyboard: Storyboard name.
    ///   - window: The window where the root controller
    ///   - window: The window where the root tab controller resides..
    ///   - bundle: Bundle of the storyboard.
    ///   - identifier: Storyboard identifier.
    ///   - configure: Configure the view controller before it is loaded.
    @discardableResult
    func root<T: UIViewController>(
        storyboard: String,
        for window: UIWindow?,
        inBundle bundle: Bundle?,
        identifier: String?,
        configure: ((T) -> Void)?) -> T?
    
    /// Adds a storyboard view controller as a child of the associated controller.
    ///
    ///     add(child: "ShowGraph") { (controller: ShowGraphViewController) in
    ///         controller.someProperty = "Abc"
    ///     }
    ///
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    /// - Parameters:
    ///   - storyboard: The child view controller storyboard.
    ///   - bundle: Bundle of the storyboard.
    ///   - identifier: Storyboard identifier.
    ///   - containerView: The target view, or nil to use the current view controller view.
    ///   - configure: A block to run on the view controller after instantiation.
    /// - Returns: The child view controller.
    @discardableResult
    func add<T: UIViewController>(
        child storyboard: String,
        inBundle bundle: Bundle?,
        identifier: String?,
        to containerView: UIView?,
        configure: ((T) -> Void)?) -> T?
    
    /// Dismisses or pops the view controller that was presented.
    ///
    /// - Parameters:
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - completion: The block to execute after the view controller is dismissed.
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

public extension Router {
    
    func present<T: UIViewController>(
        storyboard: String,
        inBundle bundle: Bundle? = nil,
        identifier: String? = nil,
        animated: Bool = true,
        modalPresentationStyle: UIModalPresentationStyle? = nil,
        modalTransitionStyle: UIModalTransitionStyle? = nil,
        configure: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil) -> T?
    {
        guard let viewController = viewController else { return nil }
        
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T else {
                assertionFailure("Invalid controller for storyboard \(storyboard).")
                return nil
        }
        
        if let modalPresentationStyle = modalPresentationStyle {
            controller.modalPresentationStyle = modalPresentationStyle
        }
        
        if let modalTransitionStyle = modalTransitionStyle {
            controller.modalTransitionStyle = modalTransitionStyle
        }
        
        configure?(controller)
        
        viewController.present(controller, animated: animated) {
            completion?(controller)
        }
        
        return controller
    }
}

public extension Router {
    
    func show<T: UIViewController>(
        storyboard: String,
        inBundle bundle: Bundle? = nil,
        identifier: String? = nil,
        configure: ((T) -> Void)? = nil) -> T?
    {
        guard let viewController = viewController else { return nil }
        
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T else {
                assertionFailure("Invalid controller for storyboard \(storyboard).")
                return nil
        }
        
        configure?(controller)
        
        viewController.show(controller, sender: viewController)
        
        return controller
    }
    
    func showDetailViewController<T: UIViewController>(
        storyboard: String,
        inBundle bundle: Bundle? = nil,
        identifier: String? = nil,
        configure: ((T) -> Void)? = nil) -> T?
    {
        guard let viewController = viewController else { return nil }
        
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T else {
                assertionFailure("Invalid controller for storyboard \(storyboard).")
                return nil
        }
        
        configure?(controller)
        
        viewController.showDetailViewController(controller, sender: viewController)
        
        return controller
    }
}

public extension Router {
    
    func show<T: UIViewController>(tab: Int, for window: UIWindow?, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) -> T? {
        guard let tabBarController = window?
            .rootViewController as? UITabBarController else {
                return nil
        }
        
        // Dismiss any alerts if applicable
        tabBarController.dismiss(animated: false, completion: nil)
        
        // Determine destination controller
        guard let controller: T = {
            // Get root navigation controller of tab if applicable
            guard let navigationController = tabBarController
                .viewControllers?[safe: tab] as? UINavigationController else {
                    return tabBarController.viewControllers?[safe: tab] as? T
            }
            
            return navigationController.viewControllers.first as? T
        }() else {
            // Select tab before exiting any way
            tabBarController.selectedIndex = tab
            return nil
        }
        
        configure?(controller)
        
        // Select tab
        tabBarController.selectedIndex = tab
        
        // Pop all views of navigation controller to go to root
        (tabBarController.selectedViewController as? UINavigationController)?
            .popToRootViewController(animated: false)
        
        completion?(controller)
        
        return controller
    }
}

public extension Router {
    
    func root<T: UIViewController>(storyboard: String, for window: UIWindow?, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) -> T? {
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T else {
                assertionFailure("Invalid controller for storyboard \(storyboard).")
                return nil
        }
        
        configure?(controller)
        
        window?.rootViewController = controller
        
        return controller
    }
}

public extension Router {
    
    func add<T: UIViewController>(child storyboard: String, inBundle bundle: Bundle? = nil, identifier: String? = nil, to containerView: UIView? = nil, configure: ((T) -> Void)? = nil) -> T? {
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T else {
                assertionFailure("Invalid controller for storyboard \(storyboard).")
                return nil
        }
        
        configure?(controller)
        
        guard let viewController = viewController else {
            return controller
        }
        
        viewController.add(child: controller, to: containerView)
        return controller
    }
}

public extension Router {
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let viewController = viewController else { return }
        
        guard let navController = viewController.navigationController else {
            viewController.dismiss(animated: animated, completion: completion)
            return
        }
        
        guard navController.viewControllers.count > 1 else {
            navController.dismiss(animated: animated, completion: completion)
            return
        }
        
        navController.popViewController(animated: animated, completion: completion)
    }
}
