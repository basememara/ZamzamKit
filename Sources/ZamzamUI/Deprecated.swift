//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-10-05.
//

#if os(iOS)
import UIKit

extension AppDisplayable where Self: UIViewController {
    
    /// Display a native alert controller modally.
    ///
    /// - Parameter error: The error details to present.
    @available(*, deprecated, message: "Every app should conform to routable in their own way. Copy this boilerplate code if needed.")
    public func display(error: AppAPI.Error) {
        // Force in next runloop via main queue since view hierachy may not be loaded yet
        DispatchQueue.main.async { [weak self] in
            self?.endRefreshing()
            self?.present(alert: error.title, message: error.message)
        }
    }
}

public extension AppRoutable {
    
    /// Dismisses the view controller that was presented.
    ///
    /// - Parameters:
    ///   - completion: The block to execute after the view controller is dismissed.
    @available(*, deprecated, message: "Every app should conform to routable in their own way. Copy this boilerplate code if needed.")
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController?.dismiss(animated: animated, completion: completion)
    }
    
    /// Dismisses or pops the view controller that was presented modally by the view controller.
    ///
    /// This method dismisses the view controller or pops it if it is part of a navigation controller.
    /// If the view controller is the last in the stack of a navigation controller, this method will
    /// dismiss the navigation controller. In other words, it will no longer be presented modally.
    ///
    /// - Parameters:
    ///   - animated: Set this value to true to animate the transition.
    ///   - completion: The block to execute after the the task finishes.
    @available(*, deprecated, message: "Every app should conform to routable in their own way. Copy this boilerplate code if needed.")
    func dismissOrPop(animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController?.dismissOrPop(animated: animated, completion: completion)
    }
    
    /// Closes the view controller and container that was presenting it.
    ///
    /// - Parameters:
    ///   - animated: Set this value to true to animate the transition.
    ///   - completion: The block to execute after the the task finishes.
    @available(*, deprecated, message: "Every app should conform to routable in their own way. Copy this boilerplate code if needed.")
    func close(animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController?.close(animated: animated, completion: completion)
    }
}
#endif

#if os(watchOS)
import WatchKit

extension AppDisplayable where Self: WKInterfaceController {
    
    /// Display a native alert controller modally.
    ///
    /// - Parameter error: The error details to present.
    @available(*, deprecated, message: "Every app should conform to routable in their own way. Copy this boilerplate code if needed.")
    public func display(error: AppAPI.Error) {
        // Force in next runloop via main queue since view hierachy may not be loaded yet
        DispatchQueue.main.async { [weak self] in
            self?.endRefreshing()
            self?.present(alert: error.title, message: error.message)
        }
    }
}

public extension AppRoutable {
    
    /// Dismisses the current interface controller from the screen.
    @available(*, deprecated, message: "Every app should conform to routable in their own way. Copy this boilerplate code if needed.")
    func dismiss() {
        viewController?.dismiss()
    }
}
#endif
