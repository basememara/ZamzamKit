//
//  Calendar.swift
//  ZamzamCore
//
//  Created by Basem Emara on 5/6/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation.NSCalendar
import Foundation.NSLocale
import Foundation.NSTimeZone

public extension Calendar {

    /// Returns a new Calendar.
    ///
    /// - parameter identifier: The kind of calendar to use.
    /// - parameter timeZone: The time zone of the calendar.
    /// - parameter locale: The locale of the calendar.
    init(identifier: Identifier, timeZone: TimeZone?, locale: Locale?) {
        self.init(identifier: identifier)

        if let timeZone = timeZone {
            self.timeZone = timeZone
        }

        if let locale = locale {
            self.locale = locale
        }
    }

    /// Returns a new Calendar.
    ///
    /// - parameter identifier: The kind of calendar to use.
    /// - parameter timeZone: The time zone of the calendar.
    init(identifier: Identifier, timeZone: TimeZone?) {
        self.init(identifier: identifier, timeZone: timeZone, locale: nil)
    }

    /// Returns a new Calendar.
    ///
    /// - parameter identifier: The kind of calendar to use.
    /// - parameter locale: The locale of the calendar.
    init(identifier: Identifier, locale: Locale?) {
        self.init(identifier: identifier, timeZone: nil, locale: locale)
    }
}

public extension Calendar.Component {

    /// The set component units of date that includes year, month, day, hour, minute, and second
    static let full: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
}
