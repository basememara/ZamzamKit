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
        timeZone: .gmt,
        locale: .posix
    )
}

public extension Calendar {
    /// Creates a calendar with a time zone and a locale.
    ///
    /// A `nil` time zone or locale leaves the one `Calendar(identifier:)` sets, which for the time zone is the device's.
    init(identifier: Identifier, timeZone: TimeZone?, locale: Locale?) {
        self.init(identifier: identifier)

        if let timeZone {
            self.timeZone = timeZone
        }

        if let locale {
            self.locale = locale
        }
    }

    /// Creates a calendar with a time zone. A `nil` time zone leaves the device's.
    init(identifier: Identifier, timeZone: TimeZone?) {
        self.init(identifier: identifier, timeZone: timeZone, locale: nil)
    }

    /// Creates a calendar with a locale, in the device's time zone. A `nil` locale leaves the one `Calendar(identifier:)` sets.
    init(identifier: Identifier, locale: Locale?) {
        self.init(identifier: identifier, timeZone: nil, locale: locale)
    }
}

public extension Calendar {
    /// Returns the interval's start, followed by each later date before its end that matches the components.
    ///
    /// The start is included whether or not it matches.
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

    /// Returns the interval's start, followed by the same time of day on each later day before its end.
    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }

    /// Returns the first moment of each day in the week that holds the date, or an empty array when the calendar finds no week.
    ///
    /// The week starts on the calendar's `firstWeekday`.
    func generateWeek(for date: Date) -> [Date] {
        guard let week = dateInterval(of: .weekOfMonth, for: date) else { return [] }
        return generateDays(for: week)
    }
}

public extension Calendar.Component {
    /// The set component units of date that includes year, month, day, hour, minute, and second
    static let full: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
}
