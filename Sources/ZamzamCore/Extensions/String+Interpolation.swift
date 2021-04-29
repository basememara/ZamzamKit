//
//  String+StringInterpolation.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-11.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSDateFormatter

public extension String.StringInterpolation {
    /// Returns a string representation of a given date formatted using the receiver’s current settings.
    ///
    /// - Parameters:
    ///   - value: The date to format.
    ///   - formatter: A formatter that converts between dates and their textual representations.
    mutating func appendInterpolation(_ value: Date, formatter: DateFormatter) {
        appendLiteral(formatter.string(from: value))
    }
}
