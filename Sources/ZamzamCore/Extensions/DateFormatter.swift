//
//  DateFormatter.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation.NSCalendar
import Foundation.NSDateFormatter
import Foundation.NSLocale
import Foundation.NSTimeZone

public extension DateFormatter {
    /// Create a date formatter.
    ///
    /// - Parameters:
    ///   - dateFormat: The date format string used by the receiver.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar for the receiver.
    ///   - locale: The locale for the receiver.
    convenience init(
        dateFormat: String,
        timeZone: TimeZone? = nil,
        calendar: Calendar? = nil,
        locale: Locale? = nil
    ) {
        self.init()

        self.dateFormat = dateFormat

        if let timeZone = timeZone ?? calendar?.timeZone {
            self.timeZone = timeZone
        }

        if let calendar {
            self.calendar = calendar
        }

        if let locale = locale ?? calendar?.locale {
            self.locale = locale
        }
    }

    /// Create a date formatter.
    ///
    /// - Parameters:
    ///   - dateFormatTemplate: The date format template used by the receiver.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar for the receiver.
    ///   - locale: The locale for the receiver.
    convenience init(
        dateFormatTemplate: String,
        timeZone: TimeZone? = nil,
        calendar: Calendar? = nil,
        locale: Locale? = nil
    ) {
        self.init()

        self.setLocalizedDateFormatFromTemplate(dateFormatTemplate)

        if let timeZone = timeZone ?? calendar?.timeZone {
            self.timeZone = timeZone
        }

        if let calendar {
            self.calendar = calendar
        }

        if let locale = locale ?? calendar?.locale {
            self.locale = locale
        }
    }
}
