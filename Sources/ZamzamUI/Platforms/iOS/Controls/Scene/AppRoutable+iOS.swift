//
//  AppRoutable+iOS.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2019-07-19.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

public extension AppRoutable {
    
    /// Dismisses the view controller that was presented.
    ///
    /// - Parameters:
    ///   - completion: The block to execute after the view controller is dismissed.
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
    func dismissOrPop(animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController?.dismissOrPop(animated: animated, completion: completion)
    }
    
    /// Closes the view controller and container that was presenting it.
    ///
    /// - Parameters:
    ///   - animated: Set this value to true to animate the transition.
    ///   - completion: The block to execute after the the task finishes.
    func close(animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController?.close(animated: animated, completion: completion)
    }
}
#endif
