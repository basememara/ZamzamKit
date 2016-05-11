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
    public convenience init(imageName: String, target: AnyObject?, action: Selector, bundleIdentifier: String? = nil) {
        self.init(image: UIImage(named: imageName,
            inBundle: bundleIdentifier != nil ? NSBundle(identifier: bundleIdentifier!) : nil,
            compatibleWithTraitCollection: nil),
            style: .Plain,
            target: target,
            action: action)
    }
    
}