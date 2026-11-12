//
//  Date.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation.NSCalendar
import Foundation.NSDate

public extension Date {
    /// A number of minutes or hours to add to a date or subtract from it. Their length is the same on every calendar.
    enum TimeIntervalUnit {
        /// A number of minutes, 60 seconds each.
        case minutes(Int)
        /// A number of hours, 3,600 seconds each.
        case hours(Int)
    }

    /// A number of days, weeks, months or years to add to a date or subtract from it, counted on the calendar given.
    ///
    /// A day keeps the time of day, so it lasts 23 or 25 hours across a clock change in the calendar's time zone.
    enum TimeIntervalUnitWithCalendar {
        /// A number of days on the calendar.
        case days(Int, Calendar)
        /// A number of weeks, seven days each on the calendar.
        case weeks(Int, Calendar)
        /// A number of months on the calendar.
        case months(Int, Calendar)
        /// A number of years on the calendar.
        case years(Int, Calendar)
    }
}

public extension Date {
    /// Returns the date moved forward by a number of calendar units, or the date itself when the calendar can't add them.
    ///
    ///     date + .days(1, calendar)
    static func + (left: Date, right: TimeIntervalUnitWithCalendar) -> Date {
        let calendar: Calendar
        let component: Calendar.Component
        let value: Int

        switch right {
        case let .days(addValue, toCalendar):
            calendar = toCalendar
            component = .day
            value = addValue
        case let .weeks(addValue, toCalendar):
            calendar = toCalendar
            component = .day
            value = addValue * 7 // All calendars have 7 days in a week
        case let .months(addValue, toCalendar):
            calendar = toCalendar
            component = .month
            value = addValue
        case let .years(addValue, toCalendar):
            calendar = toCalendar
            component = .year
            value = addValue
        }

        guard value != 0 else { return left }

        return calendar.date(
            byAdding: component,
            value: value,
            to: left
        ) ?? left
    }

    /// Returns the date moved back by a number of calendar units, or the date itself when the calendar can't subtract them.
    ///
    ///     date - .days(1, calendar)
    static func - (left: Date, right: TimeIntervalUnitWithCalendar) -> Date {
        switch right {
        case let .days(value, calendar):
            return left + .days(-value, calendar)
        case let .weeks(value, calendar):
            return left + .weeks(-value, calendar)
        case let .months(value, calendar):
            return left + .months(-value, calendar)
        case let .years(value, calendar):
            return left + .years(-value, calendar)
        }
    }
}

public extension Date {
    /// Returns the date moved forward by a number of minutes or hours.
    ///
    ///     date + .hours(1)
    static func + (left: Date, right: TimeIntervalUnit) -> Date {
        switch right {
        case let .minutes(value):
            return left + TimeInterval(value * 60)
        case let .hours(value):
            return left + TimeInterval(value * 3600)
        }
    }

    /// Returns the date moved back by a number of minutes or hours.
    ///
    ///     date - .hours(1)
    static func - (left: Date, right: TimeIntervalUnit) -> Date {
        switch right {
        case let .minutes(value):
            return left + .minutes(-value)
        case let .hours(value):
            return left + .hours(-value)
        }
    }
}

public extension Date {
    /// Moves the date forward by a number of calendar units.
    ///
    ///     date += .days(1, calendar)
    static func += (left: inout Date, right: TimeIntervalUnitWithCalendar) {
        left = left + right
    }

    /// Moves the date back by a number of calendar units.
    ///
    ///     date -= .days(1, calendar)
    static func -= (left: inout Date, right: TimeIntervalUnitWithCalendar) {
        left = left - right
    }

    /// Moves the date forward by a number of minutes or hours.
    ///
    ///     date += .hours(1)
    static func += (left: inout Date, right: TimeIntervalUnit) {
        left = left + right
    }

    /// Moves the date back by a number of minutes or hours.
    ///
    ///     date -= .hours(1)
    static func -= (left: inout Date, right: TimeIntervalUnit) {
        left = left - right
    }
}
