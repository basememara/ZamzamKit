//
//  UIImage.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/5/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension UIImage {

    /**
     Convenience initializer to handle default parameter value

     - parameter named:    The name of the image.
     - parameter inBundle: The bundle containing the image file or asset catalog. Specify nil to search the app's main bundle.

     - returns: The image object.
     */
    public convenience init?(named: String, inBundle: NSBundle?) {
        self.init(named: named, inBundle: inBundle, compatibleWithTraitCollection: nil)
    }
}