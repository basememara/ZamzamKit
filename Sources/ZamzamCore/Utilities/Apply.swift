//
//  Apply.swift
//  ZamzamCore
//
//  Created by Basem Emara on 4/29/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation.NSJSONSerialization
import Foundation.NSObject

public protocol Apply {}

public extension Apply where Self: Any {

    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label = UILabel().apply {
    ///       $0.textAlignment = .center
    ///       $0.textColor = .black
    ///       $0.text = "Hello, World!"
    ///     }
    @discardableResult
    func apply(_ block: (Self) -> Void) -> Self {
        // https://github.com/devxoul/Then
        block(self)
        return self
    }
}

extension NSObject: Apply {}
extension JSONDecoder: Apply {}
extension JSONEncoder: Apply {}
