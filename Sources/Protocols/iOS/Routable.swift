//
//  Routable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/26/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit

public protocol Routable {
    associatedtype StoryboardIdentifier: RawRepresentable
    
    @discardableResult
    func present<T: UIViewController>(storyboard: StoryboardIdentifier, inBundle bundle: Bundle?, identifier: String?, animated: Bool, modalPresentationStyle: UIModalPresentationStyle?, modalTransitionStyle: UIModalTransitionStyle?, configure: ((T) -> Void)?, completion: ((T) -> Void)?) -> UIViewController?
    
    @discardableResult
    func show<T: UIViewController>(storyboard: StoryboardIdentifier, inBundle bundle: Bundle?, identifier: String?, configure: ((T) -> Void)?) -> UIViewController?
    
    @discardableResult
    func showDetailViewController<T: UIViewController>(storyboard: StoryboardIdentifier, inBundle bundle: Bundle?, identifier: String?, configure: ((T) -> Void)?) -> UIViewController?
}

public extension Routable where Self: UIViewController, StoryboardIdentifier.RawValue == String {
    
    /// Presents the intial view controller of the specified storyboard modally.
    ///
    ///     class ViewController: UIViewController {
    ///
    ///         @IBAction func moreTapped() {
    ///             present(storyboard: .more) { (controller: MoreViewController) in
    ///                 controller.someProperty = "\(Date())"
    ///             }
    ///         }
    ///     }
    ///
    ///     extension ViewController: Routable {
    ///
    ///         enum StoryboardIdentifier: String {
    ///             case more = "More"
    ///             case login = "Login"
    ///         }
    ///     }
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
    func present<T: UIViewController>(storyboard: StoryboardIdentifier, inBundle bundle: Bundle? = nil, identifier: String? = nil, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle? = nil, modalTransitionStyle: UIModalTransitionStyle? = nil, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) -> UIViewController? {
        return RoutingLogic.present(delegate: self, storyboard: storyboard.rawValue, inBundle: bundle, identifier: identifier, animated: animated, modalPresentationStyle: modalPresentationStyle, modalTransitionStyle: modalTransitionStyle, configure: configure, completion: completion)
    }
    
    /// Present the intial view controller of the specified storyboard in the primary context.
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    ///     class ViewController: UIViewController {
    ///
    ///         @IBAction func moreTapped() {
    ///             show(storyboard: .more) { (controller: MoreViewController) in
    ///                 controller.someProperty = "\(Date())"
    ///             }
    ///         }
    ///     }
    ///
    ///     extension ViewController: Routable {
    ///
    ///         enum StoryboardIdentifier: String {
    ///             case more = "More"
    ///             case login = "Login"
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - storyboard: Storyboard name.
    ///   - bundle: Bundle of the storyboard.
    ///   - identifier: Storyboard identifier.
    ///   - configure: Configure the view controller before it is loaded.
    /// - Returns: Returns the view controller instance from the storyboard.
    func show<T: UIViewController>(storyboard: StoryboardIdentifier, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) -> UIViewController? {
        return RoutingLogic.show(delegate: self, storyboard: storyboard.rawValue, inBundle: bundle, identifier: identifier, configure: configure)
    }
    
    /// Present the intial view controller of the specified storyboard in the secondary (or detail) context.
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    /// - Parameters:
    ///   - storyboard: Storyboard name.
    ///   - bundle: Bundle of the storyboard.
    ///   - identifier: Storyboard identifier.
    ///   - configure: Configure the view controller before it is loaded.
    /// - Returns: Returns the view controller instance from the storyboard.
    func showDetailViewController<T: UIViewController>(storyboard: StoryboardIdentifier, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) -> UIViewController? {
        return RoutingLogic.showDetailViewController(delegate: self, storyboard: storyboard.rawValue, inBundle: bundle, identifier: identifier, configure: configure)
    }
}

/// Conforming types can use a weak `UIViewController` instance.
public protocol Router {
    var viewController: UIViewController? { get set }
    
    @discardableResult
    func present<T: UIViewController>(storyboard: String, inBundle bundle: Bundle?, identifier: String?, animated: Bool, modalPresentationStyle: UIModalPresentationStyle?, modalTransitionStyle: UIModalTransitionStyle?, configure: ((T) -> Void)?, completion: ((T) -> Void)?) -> UIViewController?
    
    @discardableResult
    func show<T: UIViewController>(storyboard: String, inBundle bundle: Bundle?, identifier: String?, configure: ((T) -> Void)?) -> UIViewController?
    
    @discardableResult
    func showDetailViewController<T: UIViewController>(storyboard: String, inBundle bundle: Bundle?, identifier: String?, configure: ((T) -> Void)?) -> UIViewController?
    
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

public extension Router {
    
    /// Presents the intial view controller of the specified storyboard modally.
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
    func present<T: UIViewController>(storyboard: String, inBundle bundle: Bundle? = nil, identifier: String? = nil, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle? = nil, modalTransitionStyle: UIModalTransitionStyle? = nil, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) -> UIViewController? {
        guard let viewController = viewController else { return nil }
        return RoutingLogic.present(delegate: viewController, storyboard: storyboard, inBundle: bundle, identifier: identifier, animated: animated, modalPresentationStyle: modalPresentationStyle, modalTransitionStyle: modalTransitionStyle, configure: configure, completion: completion)
    }
    
    /// Present the intial view controller of the specified storyboard in the primary context.
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    /// - Parameters:
    ///   - storyboard: Storyboard name.
    ///   - bundle: Bundle of the storyboard.
    ///   - identifier: Storyboard identifier.
    ///   - configure: Configure the view controller before it is loaded.
    /// - Returns: Returns the view controller instance from the storyboard.
    func show<T: UIViewController>(storyboard: String, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) -> UIViewController? {
        guard let viewController = viewController else { return nil }
        return RoutingLogic.show(delegate: viewController, storyboard: storyboard, inBundle: bundle, identifier: identifier, configure: configure)
    }
    
    /// Present the intial view controller of the specified storyboard in the secondary (or detail) context.
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    /// - Parameters:
    ///   - storyboard: Storyboard name.
    ///   - bundle: Bundle of the storyboard.
    ///   - identifier: Storyboard identifier.
    ///   - configure: Configure the view controller before it is loaded.
    /// - Returns: Returns the view controller instance from the storyboard.
    func showDetailViewController<T: UIViewController>(storyboard: String, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) -> UIViewController? {
        guard let viewController = viewController else { return nil }
        return RoutingLogic.showDetailViewController(delegate: viewController, storyboard: storyboard, inBundle: bundle, identifier: identifier, configure: configure)
    }
    
    /// Dismisses or pops the view controller that was presented.
    ///
    /// - Parameters:
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - completion: The block to execute after the view controller is dismissed.
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let viewController = viewController else { return }
        return RoutingLogic.dismiss(delegate: viewController, animated: animated, completion: completion)
    }
}

// MARK: - Private functions

fileprivate enum RoutingLogic {
    
    static func present<T: UIViewController>(delegate: UIViewController, storyboard: String, inBundle bundle: Bundle? = nil, identifier: String? = nil, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle? = nil, modalTransitionStyle: UIModalTransitionStyle? = nil, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) -> UIViewController? {
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
        
        delegate.present(controller, animated: animated) {
            completion?(controller)
        }
        
        return controller
    }

    static func show<T: UIViewController>(delegate: UIViewController, storyboard: String, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T else {
                assertionFailure("Invalid controller for storyboard \(storyboard).")
                return nil
        }
        
        configure?(controller)
        
        delegate.show(controller, sender: delegate)
        
        return controller
    }

    static func showDetailViewController<T: UIViewController>(delegate: UIViewController, storyboard: String, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T else {
                assertionFailure("Invalid controller for storyboard \(storyboard).")
                return nil
        }
        
        configure?(controller)
        
        delegate.showDetailViewController(controller, sender: delegate)
        
        return controller
    }
    
    static func dismiss(delegate: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let navController = delegate.navigationController else {
            delegate.dismiss(animated: true, completion: completion)
            return
        }
        
        guard navController.viewControllers.count > 1 else {
            return navController.dismiss(animated: true, completion: completion)
        }
        
        navController.popViewController(animated: true, completion: completion)
    }
}
