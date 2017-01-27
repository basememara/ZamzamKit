//
//  UIBarButtonItem.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/3/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {

    /**
     Initializes a UIBarButtonItem with an image more conveniently.

     - parameter imageName:        Image name.
     - parameter target:           Target of the context.
     - parameter action:           Action to trigger.
     - parameter bundleIdentifier: Identifier of the bundle.

     - returns: An initialized UIBarButtonItem.
     */
    convenience init(imageName: String, target: Any?, action: Selector, bundleIdentifier: String? = nil) {
        self.init(image: UIImage(named: imageName,
            in: bundleIdentifier != nil ? Bundle(identifier: bundleIdentifier!) : nil,
            compatibleWith: nil),
            style: .plain,
            target: target,
            action: action)
    }
    
}
