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
        case seconds(Int)
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
        case seconds(Int, Calendar)
        case minutes(Int, Calendar)
        case hours(Int, Calendar)
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
        case .seconds(let addValue, let toCalendar):
            calendar = toCalendar
            component = .second
            value = addValue
        case .minutes(let addValue, let toCalendar):
            calendar = toCalendar
            component = .minute
            value = addValue
        case .hours(let addValue, let toCalendar):
            calendar = toCalendar
            component = .hour
            value = addValue
        case .days(let addValue, let toCalendar):
            calendar = toCalendar
            component = .day
            value = addValue
        case .weeks(let addValue, let toCalendar):
            calendar = toCalendar
            component = .day
            value = addValue * 7 // All calendars have 7 days in a week
        case .months(let addValue, let toCalendar):
            calendar = toCalendar
            component = .month
            value = addValue
        case .years(let addValue, let toCalendar):
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

    /// Adds time interval components to a date.
    ///
    ///     Date(fromString: "2015/09/18 18:31") + .days(1)
    ///
    /// - Parameters:
    ///   - left: The date to calculate from.
    ///   - right: The time interval component to add to the date.
    static func + (left: Date, right: TimeIntervalUnit) -> Date {
        let calendar: Calendar = .current
        let newRight: TimeIntervalUnitWithCalendar

        switch right {
        case .seconds(let value):
            newRight = .seconds(value, calendar)
        case .minutes(let value):
            newRight = .minutes(value, calendar)
        case .hours(let value):
            newRight = .hours(value, calendar)
        case .days(let value):
            newRight = .days(value, calendar)
        case .weeks(let value):
            newRight = .weeks(value, calendar)
        case .months(let value):
            newRight = .months(value, calendar)
        case .years(let value):
            newRight = .years(value, calendar)
        }

        return left + newRight
    }

    static func - (left: Date, right: TimeIntervalUnit) -> Date {
        let minusRight: TimeIntervalUnit

        switch right {
        case .seconds(let value):
            minusRight = .seconds(-value)
        case .minutes(let value):
            minusRight = .minutes(-value)
        case .hours(let value):
            minusRight = .hours(-value)
        case .days(let value):
            minusRight = .days(-value)
        case .weeks(let value):
            minusRight = .weeks(-value)
        case .months(let value):
            minusRight = .months(-value)
        case .years(let value):
            minusRight = .years(-value)
        }

        return left + minusRight
    }

    static func - (left: Date, right: TimeIntervalUnitWithCalendar) -> Date {
        let minusRight: TimeIntervalUnitWithCalendar

        switch right {
        case .seconds(let value, let calendar):
            minusRight = .seconds(-value, calendar)
        case .minutes(let value, let calendar):
            minusRight = .minutes(-value, calendar)
        case .hours(let value, let calendar):
            minusRight = .hours(-value, calendar)
        case .days(let value, let calendar):
            minusRight = .days(-value, calendar)
        case .weeks(let value, let calendar):
            minusRight = .weeks(-value, calendar)
        case .months(let value, let calendar):
            minusRight = .months(-value, calendar)
        case .years(let value, let calendar):
            minusRight = .years(-value, calendar)
        }

        return left + minusRight
    }
}
