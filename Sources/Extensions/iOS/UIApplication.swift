//
//  UIApplication.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit

public extension UIApplication {
    
    /**
     Swap root controllers during run time.

     - parameter storyboard: Storyboard with intial view controller set.
     - parameter transition: Transition to perform on swap.
     
     - returns: The root view controller.
     */
    @discardableResult
    func set(root controller: UIViewController, transition: UIView.AnimationOptions = .curveEaseInOut) -> UIViewController? {
        guard let window = keyWindow ?? delegate?.window ?? nil else { return nil }
        let previous = window.rootViewController
        
        // Remove old root controller's subviews
        previous?.view?.subviews.forEach { $0.removeFromSuperview() }
        
        // Allow the previous view controller to be deallocated
        previous?.dismiss(animated: false) {
            // Remove the old root view incase it is still showing
            previous?.view.removeFromSuperview()
        }
        
        window.rootViewController = controller
        
        // Update status bar appearance using the new view controllers appearance - animate if needed
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                controller.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            controller.setNeedsStatusBarAppearanceUpdate()
        }
        
        return controller
    }
    
    /**
     Update existing home short cut.

     - parameter type:    Indentifier of shortcut item.
     - parameter handler: Handler which to modify the shortcut item.
     */
    func updateShortcutItem(_ type: String, handler: (UIMutableApplicationShortcutItem) -> UIMutableApplicationShortcutItem) {
        guard let index = shortcutItems?.index(where: { $0.type == type }),
            let item = shortcutItems?[index].mutableCopy() as? UIMutableApplicationShortcutItem
                else { return }
        
        shortcutItems?[index] = handler(item)
    }
}


