//
//  Date.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation.NSCalendar
import Foundation.NSDate
import Foundation.NSDateFormatter

public extension Date {
    /// Creates a date from its components, read on a calendar.
    ///
    ///     Date(year: 2018, month: 11, day: 1, hour: 18, minute: 15, calendar: calendar)
    ///
    /// - Parameters:
    ///   - era: The era of the date, for a calendar that counts its years in more than one.
    ///   - year: The year of the date.
    ///   - month: The month of the date.
    ///   - day: The day of the date.
    ///   - hour: The hour of the date.
    ///   - minute: The minute of the date.
    ///   - second: The second of the date.
    ///   - calendar: The calendar the components are read on, in its own time zone.
    init?(
        era: Int? = nil,
        year: Int,
        month: Int,
        day: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        calendar: Calendar
    ) {
        let components = DateComponents(
            era: era,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )

        guard let date = calendar.date(from: components) else { return nil }
        self = date
    }
}

public extension Date {
    /// Return yesterday's date.
    ///
    ///     date.yesterday(using: calendar) // "Oct 2, 2018, 10:57:11" for "Oct 3, 2018, 10:57:11"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func yesterday(using calendar: Calendar) -> Date {
        calendar.date(byAdding: .day, value: -1, to: self)
            ?? addingTimeInterval(-86400)
    }
}

public extension Date {
    /// Return tomorrow's date.
    ///
    ///     date.tomorrow(using: calendar) // "Oct 4, 2018, 10:57:11" for "Oct 3, 2018, 10:57:11"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func tomorrow(using calendar: Calendar) -> Date {
        calendar.date(byAdding: .day, value: 1, to: self)
            ?? addingTimeInterval(86400)
    }
}

public extension Date {
    /// Returns the beginning of the day.
    ///
    ///     date.startOfDay(using: calendar) // "2018/11/21 00:00:00"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func startOfDay(using calendar: Calendar) -> Date {
        calendar.startOfDay(for: self)
    }
}

public extension Date {
    /// Returns the end of the day.
    ///
    ///     date.endOfDay(using: calendar) // "2018/11/21 23:59:59"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func endOfDay(using calendar: Calendar) -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1

        return calendar.date(
            byAdding: components,
            to: startOfDay(using: calendar)
        ) ?? self
    }
}

public extension Date {
    /// Returns the beginning of the month.
    ///
    ///     date.startOfMonth(using: calendar) // "2018/11/01 00:00:00"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}

public extension Date {
    /// Returns the end of the month.
    ///
    ///     date.endOfMonth(using: calendar) // "2018/11/30 23:59:59"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func endOfMonth(using calendar: Calendar) -> Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1

        return calendar.date(
            byAdding: components,
            to: startOfMonth(using: calendar)
        ) ?? self
    }
}

public extension Date {
    /// Returns the beginning of the year.
    ///
    ///     date.startOfYear(using: calendar) // "2018/01/01 00:00:00"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func startOfYear(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year], from: self)
        ) ?? self
    }
}

public extension Date {
    /// Returns the end of the year.
    ///
    ///     date.endOfYear(using: calendar) // "2018/12/31 23:59:59"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func endOfYear(using calendar: Calendar) -> Date {
        var components = DateComponents()
        components.year = 1
        components.second = -1

        return calendar.date(
            byAdding: components,
            to: startOfYear(using: calendar)
        ) ?? self
    }
}

public extension Date {
    /// Determine if a date is between two other dates.
    ///
    /// Dates do not have to be in sequential order.
    ///
    ///     let date = Date()
    ///     let date1 = Date(timeIntervalSinceNow: 1000)
    ///     let date2 = Date(timeIntervalSinceNow: -1000)
    ///     date.isBetween(date1, date2) // true
    ///
    /// - Parameters:
    ///   - date1: first date to compare to.
    ///   - date2: second date to compare to.
    /// - Returns: true if the date is between the two given dates.
    func isBetween(_ date1: Date, _ date2: Date) -> Bool {
        // https://stackoverflow.com/a/67179166
        let minDate = min(date1, date2)
        let maxDate = max(date1, date2)

        guard self != minDate else { return true }
        guard self != maxDate else { return false }

        return DateInterval(start: minDate, end: maxDate).contains(self)
    }
}

public extension Date {
    /// Gets the decimal representation of the time.
    ///
    ///     date.timeToDecimal(using: calendar) // 18.25 at 18:15
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: The hour of the day, with the minutes as its fraction.
    func timeToDecimal(using calendar: Calendar) -> Double {
        let components = calendar.dateComponents([.hour, .minute], from: self)
        let hour = components.hour ?? 0
        let minutes = components.minute ?? 0
        return Double(hour) + (Double(minutes) / 60.0)
    }
}

public extension Date {
    /// Fixed-format for the date without time, in ASCII digits whatever the device's locale.
    ///
    /// An example use case for this function is creating a dictionary of days that group respective values by days.
    ///
    ///     date.shortString(calendar: calendar) // "2017-05-15"
    ///
    /// - Parameter calendar: The calendar the day is read on, in its own time zone.
    /// - Returns: The formatted date string.
    func shortString(calendar: Calendar) -> String {
        DateFormatter(dateFormat: "yyyy-MM-dd", calendar: calendar, locale: .posix).string(from: self)
    }
}

public extension Date {
    enum ExpandingComponent {
        case week
        case month
        case monthWithTrailingWeeks
    }

    /// Returns the starting time and duration of a given calendar component that contains a given date.
    ///
    ///     let date = Date(year: 2020, month: 4, day: 1, hour: 9, minute: 30, calendar: calendar)
    ///     date.expanding(to: .week, using: calendar) // Mar 29 - Apr 4
    ///     date.expanding(to: .month, using: calendar) // Apr 1 - Apr 30
    ///     date.expanding(to: .monthWithTrailingWeeks, using: calendar) // Mar 29 - May 2
    ///
    /// - Parameters:
    ///   - component: A date component that specifies the date interval that contains the date.
    ///   - calendar: A calendar component.
    /// - Returns: A new `DateInterval` if the starting time and duration of a component could be calculated; otherwise, nil.
    func expanding(to component: ExpandingComponent, using calendar: Calendar) -> DateInterval? {
        switch component {
        case .week:
            return calendar.dateInterval(of: .weekOfMonth, for: self)
        case .month:
            return calendar.dateInterval(of: .month, for: self)
        case .monthWithTrailingWeeks:
            guard let monthInterval = calendar.dateInterval(of: .month, for: self),
                  let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
                  let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
            else {
                return nil
            }

            return DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        }
    }
}
