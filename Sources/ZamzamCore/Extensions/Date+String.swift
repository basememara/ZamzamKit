//
//  Date+String.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-26.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSCalendar
import Foundation.NSDate
import Foundation.NSDateFormatter
import Foundation.NSLocale
import Foundation.NSTimeZone

public extension Date {
    
    /// Creates a date value initialized from a string.
    ///
    ///     Date(fromString: "2018/11/01 18:15")
    ///
    /// - Parameters:
    ///   - string: The string to parse the date from. The default is `"yyyy/MM/dd HH:mm"`.
    ///   - dateFormat: The date format string used by the receiver.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar for the receiver.
    ///   - locale: The locale for the receiver.
    init?(fromString string: String, dateFormat: String = "yyyy/MM/dd HH:mm", timeZone: TimeZone? = nil, calendar: Calendar? = nil, locale: Locale? = nil) {
        guard !string.isEmpty,
            let date = DateFormatter(dateFormat: dateFormat, timeZone: timeZone, calendar: calendar, locale: locale).date(from: string) else {
                return nil
        }
        
        self.init(timeInterval: 0, since: date)
    }
}

public extension Date {
    
    /// Returns a string representation of a given date formatted using the receiver’s current settings.
    ///
    ///     Date().string(format: "MMM d, h:mm a") // "Jan 3, 8:43 PM"
    ///
    /// - Parameters:
    ///   - format: The date format string used by the receiver.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar for the receiver.
    ///   - locale: The locale for the receiver.
    /// - Returns: The string representation of the given date.
    func string(format: String, timeZone: TimeZone? = nil, calendar: Calendar? = nil, locale: Locale? = nil) -> String {
        DateFormatter(dateFormat: format, timeZone: timeZone, calendar: calendar, locale: locale).string(from: self)
    }
    
    /// Returns a string representation of a given date formatted using the receiver’s current settings.
    ///
    ///     Date().string(style: .short) // "1/12/17"
    ///     Date().string(style: .medium) // "Jan 12, 2017"
    ///     Date().string(style: .long) // "January 12, 2017"
    ///     Date().string(style: .full) // "Thursday, January 12, 2017"
    ///     Date().string(style: .full, withTime: .medium) // "Thursday, January 12, 2017 at 4:45:23 PM"
    ///
    /// - Parameters:
    ///   - dateStyle: The date style string used by the receiver.
    ///   - timeStyle: The time style string used by the receiver.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar for the receiver.
    ///   - locale: The locale for the receiver.
    /// - Returns: The string representation of the given date.
    func string(style dateStyle: DateFormatter.Style, withTime timeStyle: DateFormatter.Style = .none, timeZone: TimeZone? = nil, calendar: Calendar? = nil, locale: Locale? = nil) -> String {
        DateFormatter(dateStyle: dateStyle, timeStyle: timeStyle, timeZone: timeZone, calendar: calendar, locale: locale).string(from: self)
    }
    
    /// Returns a string representation of a given date formatted using the receiver’s formatter.
    ///
    ///     Date().string(formatter: .MM_dd_yyyy_HH_mm) // "03-15-2020 22:46"
    ///
    /// - Parameters:
    ///   - formatter: The date formatter to use.
    /// - Returns: The string representation of the given date.
    func string(formatter: DateFormatter) -> String {
        formatter.string(from: self)
    }
}

public extension Date {
    
    /// Fixed-format for the date without time.
    ///
    /// An example use case for this function is creating a dictionary of days that group respective values by days.
    ///
    ///     Date().shortString() // "2017-05-15"
    ///
    /// - Parameter timeZone: Time zone to determine day boundries of the date.
    /// - Returns: The formatted date string.
    func shortString(timeZone: TimeZone? = nil, calendar: Calendar? = nil, locale: Locale? = nil) -> String {
        DateFormatter(dateFormat: "yyyy-MM-dd", timeZone: timeZone, calendar: calendar, locale: locale).string(from: self)
    }
    
    /// Formats time interval for display timer.
    ///
    ///     Date(fromString: "2016/03/22 09:45").timerString(
    ///         from: Date(fromString: "2016/03/22 09:40")
    ///     ) // "00:05:00"
    ///
    /// - Parameter
    ///   - date: The date to countdown from.
    ///   - positivePrefix: THe prefix string to prepend to the timer.
    /// - Returns: The formatted timer as hh:mm:ss.
    func timerString(from date: Date = Date(), positivePrefix: String = "+") -> String {
        let seconds = Int(timeIntervalSince(date))
        let prefix = seconds < 0 ? positivePrefix : ""
        let hr = abs(seconds / 3600)
        let min = abs(seconds / 60 % 60)
        let sec = abs(seconds % 60)
        return .localizedStringWithFormat("%@%02i:%02i:%02i", prefix, hr, min, sec)
    }
}
