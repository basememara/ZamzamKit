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
    /// Represents a specified number of a calendar component unit.
    ///
    /// You use `TimeIntervalUnit` values to do date calculations.
    enum TimeIntervalUnit {
        case minutes(Int)
        case hours(Int)
        case days(Int)
        case weeks(Int)
        case months(Int)
        case years(Int)
    }

    /// Represents a specified number of a calendar component unit for a calendar.
    ///
    /// You use `TimeIntervalUnitWithCalendar` values to do date calculations.
    enum TimeIntervalUnitWithCalendar {
        case days(Int, Calendar)
        case weeks(Int, Calendar)
        case months(Int, Calendar)
        case years(Int, Calendar)
    }

    /// Adds time interval components to a date for the calendar.
    ///
    ///     Date(fromString: "1440/02/30 18:31", calendar) + .days(1, calendar)
    ///
    /// - Parameters:
    ///   - left: The date to calculate from.
    ///   - right: The time interval component with calendar to add to the date.
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

    /// Subtracts time interval components from a date for the calendar.
    ///
    ///     Date(fromString: "1440/02/30 18:31", calendar) - .days(1, calendar)
    ///
    /// - Parameters:
    ///   - left: The date to calculate from.
    ///   - right: The time interval component with calendar to subtracts from the date.
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

    /// Adds time interval components to a date.
    ///
    ///     Date(fromString: "2015/09/18 18:31") + .days(1)
    ///
    /// - Parameters:
    ///   - left: The date to calculate from.
    ///   - right: The time interval component to add to the date.
    static func + (left: Date, right: TimeIntervalUnit) -> Date {
        switch right {
        case let .minutes(value):
            return left + TimeInterval(value * 60)
        case let .hours(value):
            return left + TimeInterval(value * 3600)
        case let .days(value):
            return left + .days(value, .current)
        case let .weeks(value):
            return left + .weeks(value, .current)
        case let .months(value):
            return left + .months(value, .current)
        case let .years(value):
            return left + .years(value, .current)
        }
    }

    /// Subtracts time interval components from a date.
    ///
    ///     Date(fromString: "2015/09/18 18:31") - .days(1)
    ///
    /// - Parameters:
    ///   - left: The date to calculate from.
    ///   - right: The time interval component to subtract from the date.
    static func - (left: Date, right: TimeIntervalUnit) -> Date {
        switch right {
        case let .minutes(value):
            return left + .minutes(-value)
        case let .hours(value):
            return left + .hours(-value)
        case let .days(value):
            return left + .days(-value)
        case let .weeks(value):
            return left + .weeks(-value)
        case let .months(value):
            return left + .months(-value)
        case let .years(value):
            return left + .years(-value)
        }
    }
}
