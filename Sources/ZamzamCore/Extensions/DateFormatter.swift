//
//  DateFormatter.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation.NSDateFormatter
import Foundation.NSCalendar
import Foundation.NSLocale
import Foundation.NSTimeZone

public extension DateFormatter {
    /// The date format string used for parsing ISO8601 dates, i.e. "2021-02-25T05:34:47+00:00".
    static let dateFormat8601 = "yyyy-MM-dd'T'HH:mm:ssZ"

    /// The date formatter used for parsing ISO8601 dates, i.e. "2021-02-25T05:34:47+00:00".
    static let iso8601Formatter = DateFormatter(iso8601Format: dateFormat8601)
}

public extension DateFormatter {
    /// The date format string used for parsing Zulu dates, i.e. "2021-02-03T20:19:55.317Z".
    static let dateFormatZ = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

    /// The date formatter used for parsing Zulu dates, i.e. "2021-02-03T20:19:55.317Z".
    static let zuluFormatter = DateFormatter(iso8601Format: dateFormatZ)
}

public extension DateFormatter {
    /// A formatter that converts between dates and their ISO 8601 string representations.
    ///
    /// When `JSONEncoder` accepts a custom `ISO8601DateFormatter`, this convenience initializer will no longer be needed.
    ///
    /// - Parameter dateFormat: The date format string used by the receiver.
    convenience init(iso8601Format dateFormat: String) {
        self.init(
            dateFormat: dateFormat,
            timeZone: .posix,
            calendar: Calendar(identifier: .iso8601),
            locale: .posix
        )
    }
}

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

        if let calendar = calendar {
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

        if let calendar = calendar {
            self.calendar = calendar
        }

        if let locale = locale ?? calendar?.locale {
            self.locale = locale
        }
    }

    /// Create a date formatter.
    ///
    /// - Parameters:
    ///   - dateStyle: The date style of the receiver.
    ///   - timeStyle: The time style of the receiver. The default is `.none`.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar for the receiver.
    ///   - locale: The locale for the receiver.
    convenience init(
        dateStyle: DateFormatter.Style,
        timeStyle: DateFormatter.Style = .none,
        timeZone: TimeZone? = nil,
        calendar: Calendar? = nil,
        locale: Locale? = nil
    ) {
        self.init()

        self.dateStyle = dateStyle
        self.timeStyle = timeStyle

        if let timeZone = timeZone ?? calendar?.timeZone {
            self.timeZone = timeZone
        }

        if let calendar = calendar {
            self.calendar = calendar
        }

        if let locale = locale ?? calendar?.locale {
            self.locale = locale
        }
    }
}
