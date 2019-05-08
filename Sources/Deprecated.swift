//
//  Deprecated.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2018-11-01.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

public extension String {
    
    @available(*, unavailable, renamed: "String.replacing(regex:)")
    func replace(regex: String, with replacement: String, caseSensitive: Bool = false) -> String {
        return replacing(regex: regex, with: replacement, caseSensitive: caseSensitive)
    }
    
    @available(*, unavailable, renamed: "String.match(regex:)")
    func match(_ pattern: String, caseSensitive: Bool = false) -> Bool {
        return match(regex: pattern)
    }
    
    @available(*, unavailable, renamed: "separated")
    func separate(every: Int, with separator: String) -> String {
        return separated(every: every, with: separator)
    }
}

public extension Date {
    
    @available(*, unavailable, renamed: "Date.isBeyond(_:bySeconds:)")
    func hasElapsed(seconds: Int, from date: Date = Date()) -> Bool {
        return date.timeIntervalSince(self).seconds > seconds
    }
    
    @available(*, unavailable, message: "Use Date() + .years(5)")
    func increment(years: Int, calendar: Calendar = .current) -> Date {
        guard years != 0 else { return self }
        return calendar.date(
            byAdding: .year,
            value: years,
            to: self
        )!
    }
    
    @available(*, unavailable, message: "Use Date() + .months(5)")
    func increment(months: Int, calendar: Calendar = .current) -> Date {
        guard months != 0 else { return self }
        return calendar.date(
            byAdding: .month,
            value: months,
            to: self
        )!
    }
    
    @available(*, unavailable, message: "Use Date() + .days(5)")
    func increment(days: Int, calendar: Calendar = .current) -> Date {
        guard days != 0 else { return self }
        return calendar.date(
            byAdding: .day,
            value: days,
            to: self
        )!
    }
    
    @available(*, unavailable, message: "Use Date() + .minutes(5)")
    func increment(minutes: Int, calendar: Calendar = .current) -> Date {
        guard minutes != 0 else { return self }
        return calendar.date(
            byAdding: .minute,
            value: minutes,
            to: self
        )!
    }
    
    @available(*, unavailable)
    func incrementDayIfPast(calendar: Calendar = .current) -> Date {
        return isPast ? self + .days(1, calendar) : self
    }
}

@available(*, unavailable, renamed: "UserDefaults.Keys")
open class DefaultsKeys {
    fileprivate init() {}
}

@available(*, unavailable, renamed: "UserDefaults.Key")
open class DefaultsKey<ValueType>: UserDefaults.Keys {
    public let name: String
    
    public init(_ key: String) {
        self.name = key
        super.init()
    }
}

public extension Array {
    
    @available(*, unavailable, message: "Use collection[safe: index]")
    func get(_ index: Int) -> Element? {
        guard startIndex..<endIndex ~= index else { return nil }
        return self[index]
    }
}

public extension ArraySlice {
    
    @available(*, unavailable, message: "Use collection[safe: index]")
    func get(_ index: Int) -> Element? {
        guard startIndex..<endIndex ~= index else { return nil }
        return self[safe: index]
    }
}

public enum Result<Value, ErrorType: Error> {
    case success(Value)
    case failure(ErrorType)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    @available(*, deprecated, message: "This method will be removed soon. Use methods defined in `Swift.Result`.")
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    @available(*, deprecated, message: "This method will be removed soon. Use methods defined in `Swift.Result`.")
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    @available(*, deprecated, message: "This method will be removed soon. Use `get() throws -> Success` instead.")
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    @available(*, deprecated, message: "This method will be removed soon. Use `get() throws -> Success` instead.")
    public var error: ErrorType? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

public extension Dictionary where Value: Any {
    
    @available(*, deprecated, message: "Use `compactMapValues` that has been introduced in Swift 5.")
    mutating func removeAllNils() -> [Key] {
        let keysWithNull = filter { $0.value is NSNull }.map { $0.key }
        keysWithNull.forEach { removeValue(forKey: $0) }
        return keysWithNull
    }
}

public extension Dictionary where Value == Optional<Any> {
    
    @available(*, deprecated, message: "Use `compactMapValues` that has been introduced in Swift 5.")
    mutating func removeAllNils() -> [Key] {
        let keysWithNull = filter { $0.value == nil }.map { $0.key }
        keysWithNull.forEach { removeValue(forKey: $0) }
        return keysWithNull
    }
}

@available(*, unavailable, renamed: "ScrollViewWithKeyboard")
open class KeyboardScrollView: ScrollViewWithKeyboard {}

#if os(iOS) || os(watchOS)
@available(*, unavailable, renamed: "LocationWorker")
public class LocationsWorker: LocationWorker {
    
}

@available(*, unavailable, renamed: "LocationWorkerType")
public protocol LocationsWorkerType: LocationWorkerType {
    
}
#endif

#if os(iOS)
public extension UICollectionView {
    
    @available(*, unavailable, renamed: "register(cell:)")
    func register<T: UICollectionViewCell>(nib type: T.Type, withReuseIdentifier identifier: String = UICollectionView.defaultCellIdentifier, inBundle bundle: Bundle? = nil) {
        register(cell: type, withReuseIdentifier: identifier, inBundle: bundle)
    }
}
#endif

@available(*, deprecated, message: "Just call show/present on the view controller object itself within your AppRoutable implementation.")
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

public extension UIWindow {
    
    @available(*, unavailable, renamed: "visibleViewController")
    var topViewController: UIViewController? {
        return visibleViewController
    }
}
