//
//  String+StringInterpolation.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2020-03-11.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSDateFormatter

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
