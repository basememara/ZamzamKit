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
    /// Creates a formatter with a fixed format string.
    ///
    /// A `nil` time zone or locale takes the calendar's. With no calendar either, the formatter keeps its defaults, which
    /// are the device's.
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

    /// Creates a formatter whose format is the localized form of a template.
    ///
    /// A `nil` time zone or locale takes the calendar's. The template is resolved once, when the formatter is created,
    /// in the formatter's locale: the one passed, else the calendar's, else the device's.
    convenience init(
        dateFormatTemplate: String,
        timeZone: TimeZone? = nil,
        calendar: Calendar? = nil,
        locale: Locale? = nil
    ) {
        self.init()

        if let timeZone = timeZone ?? calendar?.timeZone {
            self.timeZone = timeZone
        }

        if let calendar {
            self.calendar = calendar
        }

        if let locale = locale ?? calendar?.locale {
            self.locale = locale
        }

        self.setLocalizedDateFormatFromTemplate(dateFormatTemplate)
    }
}
