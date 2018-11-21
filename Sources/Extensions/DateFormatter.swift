//
//  NSDateFormatter.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension DateFormatter {
    
    /// Create a date formatter.
    ///
    /// - Parameters:
    ///   - dateFormat: The date format string used by the receiver.
    ///   - timeZone: The time zone for the receiver.
    convenience init(dateFormat: String, timeZone: TimeZone? = nil) {
        self.init()
        self.dateFormat = dateFormat
        
        if let timeZone = timeZone {
            self.timeZone = timeZone
        }
    }
    
}
