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
    
    func present<T: UIViewController>(storyboard: StoryboardIdentifier, inBundle bundle: Bundle?, identifier: String?, animated: Bool, modalPresentationStyle: UIModalPresentationStyle?, modalTransitionStyle: UIModalTransitionStyle?, configure: ((T) -> Void)?, completion: ((T) -> Void)?)
    func show<T: UIViewController>(storyboard: StoryboardIdentifier, inBundle bundle: Bundle?, identifier: String?, configure: ((T) -> Void)?)
    func showDetailViewController<T: UIViewController>(storyboard: StoryboardIdentifier, inBundle bundle: Bundle?, identifier: String?, configure: ((T) -> Void)?)
}

public extension Routable where Self: UIViewController, StoryboardIdentifier.RawValue == String {
    
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
    func present<T: UIViewController>(storyboard: StoryboardIdentifier, inBundle bundle: Bundle? = nil, identifier: String? = nil, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle? = nil, modalTransitionStyle: UIModalTransitionStyle? = nil, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) {
        RoutingLogic.present(delegate: self, storyboard: storyboard.rawValue, inBundle: bundle, identifier: identifier, animated: animated, modalPresentationStyle: modalPresentationStyle, modalTransitionStyle: modalTransitionStyle, configure: configure, completion: completion)
    }
    
    /// Present the intial view controller of the specified storyboard in the primary context.
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    /// - Parameters:
    ///   - storyboard: Storyboard name.
    ///   - bundle: Bundle of the storyboard.
    ///   - identifier: Storyboard identifier.
    ///   - configure: Configure the view controller before it is loaded.
    func show<T: UIViewController>(storyboard: StoryboardIdentifier, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        RoutingLogic.show(delegate: self, storyboard: storyboard.rawValue, inBundle: bundle, identifier: identifier, configure: configure)
    }
    
    /// Present the intial view controller of the specified storyboard in the secondary (or detail) context.
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    /// - Parameters:
    ///   - storyboard: Storyboard name.
    ///   - bundle: Bundle of the storyboard.
    ///   - identifier: Storyboard identifier.
    ///   - configure: Configure the view controller before it is loaded.
    func showDetailViewController<T: UIViewController>(storyboard: StoryboardIdentifier, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        RoutingLogic.showDetailViewController(delegate: self, storyboard: storyboard.rawValue, inBundle: bundle, identifier: identifier, configure: configure)
    }
}

public protocol Router {
    var viewController: UIViewController? { get set }
    
    func present<T: UIViewController>(storyboard: String, inBundle bundle: Bundle?, identifier: String?, animated: Bool, modalPresentationStyle: UIModalPresentationStyle?, modalTransitionStyle: UIModalTransitionStyle?, configure: ((T) -> Void)?, completion: ((T) -> Void)?)
    func show<T: UIViewController>(storyboard: String, inBundle bundle: Bundle?, identifier: String?, configure: ((T) -> Void)?)
    func showDetailViewController<T: UIViewController>(storyboard: String, inBundle bundle: Bundle?, identifier: String?, configure: ((T) -> Void)?)
    
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
    func present<T: UIViewController>(storyboard: String, inBundle bundle: Bundle? = nil, identifier: String? = nil, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle? = nil, modalTransitionStyle: UIModalTransitionStyle? = nil, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) {
        guard let viewController = viewController else { return }
        RoutingLogic.present(delegate: viewController, storyboard: storyboard, inBundle: bundle, identifier: identifier, animated: animated, modalPresentationStyle: modalPresentationStyle, modalTransitionStyle: modalTransitionStyle, configure: configure, completion: completion)
    }
    
    /// Present the intial view controller of the specified storyboard in the primary context.
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    /// - Parameters:
    ///   - storyboard: Storyboard name.
    ///   - bundle: Bundle of the storyboard.
    ///   - identifier: Storyboard identifier.
    ///   - configure: Configure the view controller before it is loaded.
    func show<T: UIViewController>(storyboard: String, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        guard let viewController = viewController else { return }
        RoutingLogic.show(delegate: viewController, storyboard: storyboard, inBundle: bundle, identifier: identifier, configure: configure)
    }
    
    /// Present the intial view controller of the specified storyboard in the secondary (or detail) context.
    /// Set the initial view controller in the target storyboard or specify the identifier.
    ///
    /// - Parameters:
    ///   - storyboard: Storyboard name.
    ///   - bundle: Bundle of the storyboard.
    ///   - identifier: Storyboard identifier.
    ///   - configure: Configure the view controller before it is loaded.
    func showDetailViewController<T: UIViewController>(storyboard: String, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        guard let viewController = viewController else { return }
        RoutingLogic.showDetailViewController(delegate: viewController, storyboard: storyboard, inBundle: bundle, identifier: identifier, configure: configure)
    }
    
    /// Dismisses or pops the view controller that was presented.
    ///
    /// - Parameters:
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - completion: The block to execute after the view controller is dismissed.
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let viewController = viewController else { return }
        RoutingLogic.dismiss(delegate: viewController, animated: animated, completion: completion)
    }
}

// MARK: - Private functions

fileprivate enum RoutingLogic {
    
    static func present<T: UIViewController>(delegate: UIViewController, storyboard: String, inBundle bundle: Bundle? = nil, identifier: String? = nil, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle? = nil, modalTransitionStyle: UIModalTransitionStyle? = nil, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T else {
                return assertionFailure("Invalid controller for storyboard \(storyboard).")
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
    }

    static func show<T: UIViewController>(delegate: UIViewController, storyboard: String, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T else {
                return assertionFailure("Invalid controller for storyboard \(storyboard).")
        }
        
        configure?(controller)
        
        delegate.show(controller, sender: delegate)
    }

    static func showDetailViewController<T: UIViewController>(delegate: UIViewController, storyboard: String, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController()) as? T else {
                return assertionFailure("Invalid controller for storyboard \(storyboard).")
        }
        
        configure?(controller)
        
        delegate.showDetailViewController(controller, sender: delegate)
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
