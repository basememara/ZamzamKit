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
    convenience init?(named: String, inBundle: Bundle?) {
        self.init(named: named, in: inBundle, compatibleWith: nil)
    }

    /// Shorthand for always draw the original image, without treating it as a template.
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }

    /// Shorthand for always draw the image as a template image, ignoring its color information.
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
}
