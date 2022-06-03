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
    ///     Date(year: 2018, month: 11, day: 1, hour: 18, minute: 15)
    ///
    /// - Parameters:
    ///   - year: The year of the date.
    ///   - month: The year of the date.
    ///   - day: The year of the date.
    ///   - hour: The year of the date.
    ///   - minute: The year of the date.
    ///   - second: The year of the date.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar for the receiver.
    init?(
        era: Int? = nil,
        year: Int,
        month: Int,
        day: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        timeZone: TimeZone? = nil,
        calendar: Calendar = .current
    ) {
        var calendar = calendar
        let components = DateComponents(
            era: era,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )

        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }

        guard let date = calendar.date(from: components) else { return nil }
        self = date
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
}
