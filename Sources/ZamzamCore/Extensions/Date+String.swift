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
    init?(
        fromString string: String,
        dateFormat: String = "yyyy/MM/dd HH:mm",
        timeZone: TimeZone? = nil,
        calendar: Calendar? = nil,
        locale: Locale? = nil
    ) {
        guard !string.isEmpty,
            let date = DateFormatter(dateFormat: dateFormat, timeZone: timeZone, calendar: calendar, locale: locale).date(from: string)
        else {
            return nil
        }

        self.init(timeInterval: 0, since: date)
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
    /// - Parameters:
    ///   - date: The date to countdown from.
    ///   - positivePrefix: The prefix string to prepend to the timer.
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

public extension Date {
    /// Date name format.
    ///
    /// - threeLetters: 3 letter abbreviation of date name.
    /// - oneLetter: 1 letter abbreviation of date name.
    /// - full: Full date name.
    enum NameStyle {
        /// 3 letter abbreviation of date name.
        case threeLetters

        /// 1 letter abbreviation of date name.
        case oneLetter

        /// Full date name.
        case full
    }

    /// Day name from date.
    ///
    ///     Date().name(ofDay: .oneLetter) -> "T"
    ///     Date().name(ofDay: .threeLetters) -> "Thu"
    ///     Date().name(ofDay: .full) -> "Thursday"
    ///
    /// The string returned is localized.
    ///
    /// - Parameter style: The style of day name.
    /// - Returns: The day name string (example: W, Wed, Wednesday).
    func name(ofDay style: NameStyle) -> String {
        // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        let dateFormatter = DateFormatter()
        let format: String

        switch style {
        case .oneLetter:
            format = "EEEEE"
        case .threeLetters:
            format = "EEE"
        case .full:
            format = "EEEE"
        }

        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    /// Month name from date.
    ///
    ///     Date().name(ofMonth: .oneLetter) -> "J"
    ///     Date().name(ofMonth: .threeLetters) -> "Jan"
    ///     Date().name(ofMonth: .full) -> "January"
    ///
    /// The string returned is localized.
    ///
    /// - Parameter style: The style of month name.
    /// - Returns: The month name string (example: D, Dec, December).
    func name(ofMonth style: NameStyle) -> String {
        // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        let dateFormatter = DateFormatter()
        let format: String

        switch style {
        case .oneLetter:
            format = "MMMMM"
        case .threeLetters:
            format = "MMM"
        case .full:
            format = "MMMM"
        }

        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }
}
