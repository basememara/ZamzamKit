//
//  Then.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/29/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

public protocol Then {}

public extension Then where Self: Any {

    /// Makes it available to set properties with closures just after initializing.
    /// https://github.com/devxoul/Then
    ///
    ///     let label = UILabel().then {
    ///       $0.textAlignment = .center
    ///       $0.textColor = UIColor.black
    ///       $0.text = "Hello, World!"
    ///     }
    func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Then {}
