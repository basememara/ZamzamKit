//
//  UINavigationBar.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/21/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit

public extension UINavigationBar {

    /// Set transparent navigation bar
    var transparent: Bool {
        // http://stackoverflow.com/questions/2315862/make-uinavigationbar-transparent
        
        get {
            return backgroundColor == .clear
        }
        
        set {
            if newValue {
                // Override point for customization after application launch.
                // Sets background to a blank/empty image
                setBackgroundImage(UIImage(), for: .default)
                
                // Sets shadow (line below the bar) to a blank image
                shadowImage = UIImage()
                
                // Sets the translucent background color
                backgroundColor = .clear
                
                // Set translucent. (Default value is already true, so this can be removed if desired.)
                isTranslucent = true
            } else {
                setBackgroundImage(nil, for: .default)
                shadowImage = nil
                backgroundColor = nil
            }
        }
    }
}
