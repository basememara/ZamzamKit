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
    /// Unix representation of calendar usually used for normalizing.
    ///
    /// This is a `Gregorian` calendar with `UTC` time zone and `en_US_POSIX` locale.
    static let posix = Calendar(
        identifier: .gregorian,
        timeZone: .posix,
        locale: .posix
    )
}

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

public extension Calendar {
    /// Returns the dates which match a given set of components between the specified dates.
    /// - Parameters:
    ///   - dateInterval: The `DateInterval` between which to compute the search.
    ///   - components: The `DateComponents` to use as input to the search algorithm.
    /// - Returns: The dates between the date interval that match the specified date component.
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]

        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date else { return }

            guard date < dateInterval.end else {
                stop = true
                return
            }

            dates.append(date)
        }

        return dates
    }

    /// Returns the days between the dates.
    /// - Parameter dateInterval: The `DateInterval` between which to compute the search.
    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }

    /// Returns the days of the week for the given date.
    /// - Parameter date: The `Date` which to expand the search for the week it belongs to.
    func generateWeek(for date: Date) -> [Date] {
        guard let week = dateInterval(of: .weekOfMonth, for: date) else { return [] }
        return generateDays(for: week)
    }
}

public extension Calendar.Component {
    /// The set component units of date that includes year, month, day, hour, minute, and second
    static let full: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
}
