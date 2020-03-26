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

public extension String.StringInterpolation {
    
    private static let formatter = DateFormatter(
        iso8601Format: "yyyy-MM-dd HH:mm:ss.SSS"
    )
    
    /// Appends a date formatted timestamp to the interpolation.
    ///
    ///     print("Console log at \(timestamp: Date())")
    ///
    /// - Parameter timestamp: The date to format.
    mutating func appendInterpolation(timestamp: Date) {
        appendLiteral(Self.formatter.string(from: timestamp))
    }
}
