//
//  UITabBarController.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2019-05-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

public extension UITabBarController {
    
    /// Setting this property changes the selected view controller to the one at the designated index in the viewControllers array.
    ///
    /// Using this method provides more safety than assigning the selected view controller directly,
    /// such as dismissing and popping all view controllers before setting. These steps ensure
    /// the selected tab is shown in a fresh state.
    ///
    ///
    /// - Parameters:
    ///   - index: The index of the view controller associated with the currently selected tab item.
    ///   - configure: Configure the view controller before it is loaded.
    ///   - completion: Completion the view controller after it is loaded.
    /// - Returns: Returns the view controller instance from the storyboard.
    func setSelected<T: UIViewController>(index: Int, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) -> T? {
        // Dismiss any alerts if applicable
        dismiss(animated: false)
        
        // Determine destination controller
        guard let controller: T = {
            // Get root navigation controller of tab if applicable
            guard let navigationController = viewControllers?[safe: index] as? UINavigationController else {
                return viewControllers?[safe: index] as? T
            }
            
            return navigationController.viewControllers.first as? T
        }() else {
            // Select tab before exiting any way
            selectedIndex = index
            return nil
        }
        
        configure?(controller)
        
        // Select tab
        selectedIndex = index
        
        // Pop all views of navigation controller to go to root
        (selectedViewController as? UINavigationController)?
            .popToRootViewController(animated: false)
        
        completion?(controller)
        
        return controller
    }
}
