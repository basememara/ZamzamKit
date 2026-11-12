//
//  Apply.swift
//  ZamzamCore
//
//  Created by Basem Emara on 4/29/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation.NSJSONSerialization
import Foundation.NSObject

/// A type whose new instance can be set up in a closure. `NSObject`, `JSONDecoder` and `JSONEncoder` adopt it.
public protocol Apply {}

public extension Apply where Self: Any {
    /// Passes the instance to a closure that sets it up, then returns the instance.
    ///
    ///     let formatter = DateFormatter().apply {
    ///         $0.dateStyle = .medium
    ///         $0.timeStyle = .none
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
