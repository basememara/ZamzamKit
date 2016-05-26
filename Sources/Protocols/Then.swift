//
//  Then.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/26/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

/**
 *  Super sweet syntactic sugar for Swift initializers.
 *  https://github.com/devxoul/Then
 */
public protocol Then {}

extension Then {

    /// Makes it available to set properties with closures.
    ///
    ///     let label = UILabel().then {
    ///         $0.textAlignment = .Center
    ///         $0.textColor = UIColor.blackColor()
    ///         $0.text = "Hello, World!"
    ///     }
    public func then(@noescape block: inout Self -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }

}

extension NSObject: Then {}