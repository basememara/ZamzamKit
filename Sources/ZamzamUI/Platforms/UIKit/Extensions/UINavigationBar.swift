//
//  UINavigationBar.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2/21/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UINavigationBar {
    /// Set transparent navigation bar
    var transparent: Bool {
        // http://stackoverflow.com/questions/2315862/make-uinavigationbar-transparent

        get { backgroundColor == .clear }

        set {
            guard newValue else {
                setBackgroundImage(nil, for: .default)
                shadowImage = nil
                backgroundColor = nil
                return
            }

            // Override point for customization after application launch.
            // Sets background to a blank/empty image
            setBackgroundImage(UIImage(), for: .default)

            // Sets shadow (line below the bar) to a blank image
            shadowImage = UIImage()

            // Sets the translucent background color
            backgroundColor = .clear

            // Set translucent. (Default value is already true, so this can be removed if desired.)
            isTranslucent = true
        }
    }
}

public extension UINavigationBar {
    /// Sets whether the navigation bar shadow is hidden.
    ///
    /// - Parameter hidden: Specify true to hide the navigation bar shadow or false to show it.
    func setShadowHidden(_ hidden: Bool) {
        // https://stackoverflow.com/a/38745391
        setValue(hidden, forKey: "hidesShadow")
    }
}
#endif
