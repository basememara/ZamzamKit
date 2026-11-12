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
    /// Creates a date from its components, read on a calendar, or `nil` when the calendar can't form a date from them.
    ///
    ///     Date(year: 2018, month: 11, day: 1, hour: 18, minute: 15, calendar: calendar)
    ///
    /// - Parameters:
    ///   - era: The era of the date, for a calendar that counts its years in more than one.
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
    /// Returns the same time on the previous day of the calendar.
    ///
    ///     date.yesterday(using: calendar) // "Oct 2, 2018, 10:57:11" for "Oct 3, 2018, 10:57:11"
    func yesterday(using calendar: Calendar) -> Date {
        calendar.date(byAdding: .day, value: -1, to: self)
            ?? addingTimeInterval(-86400)
    }
}

public extension Date {
    /// Returns the same time on the next day of the calendar.
    ///
    ///     date.tomorrow(using: calendar) // "Oct 4, 2018, 10:57:11" for "Oct 3, 2018, 10:57:11"
    func tomorrow(using calendar: Calendar) -> Date {
        calendar.date(byAdding: .day, value: 1, to: self)
            ?? addingTimeInterval(86400)
    }
}

public extension Date {
    /// Returns the first moment of the date's day on the calendar.
    ///
    ///     date.startOfDay(using: calendar) // "2018/11/21 00:00:00"
    func startOfDay(using calendar: Calendar) -> Date {
        calendar.startOfDay(for: self)
    }
}

public extension Date {
    /// Returns the last second of the date's day on the calendar.
    ///
    ///     date.endOfDay(using: calendar) // "2018/11/21 23:59:59"
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
    /// Returns the first moment of the date's month on the calendar.
    ///
    ///     date.startOfMonth(using: calendar) // "2018/11/01 00:00:00"
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}

public extension Date {
    /// Returns the last second of the date's month on the calendar.
    ///
    ///     date.endOfMonth(using: calendar) // "2018/11/30 23:59:59"
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
    /// Returns the first moment of the date's year on the calendar.
    ///
    ///     date.startOfYear(using: calendar) // "2018/01/01 00:00:00"
    func startOfYear(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year], from: self)
        ) ?? self
    }
}

public extension Date {
    /// Returns the last second of the date's year on the calendar.
    ///
    ///     date.endOfYear(using: calendar) // "2018/12/31 23:59:59"
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
    /// Returns whether the date falls between two others, given in either order.
    ///
    /// The earlier bound counts as between and the later one doesn't.
    ///
    ///     let start = Date(timeIntervalSinceReferenceDate: 0)
    ///     let end = start + 60
    ///
    ///     (start + 30).isBetween(end, start) // true
    ///     start.isBetween(start, end) // true
    ///     end.isBetween(start, end) // false
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
    /// Returns the hour of the day with the minutes as its fraction, read on the calendar. Seconds are left out.
    ///
    ///     date.timeToDecimal(using: calendar) // 18.25 at 18:15
    func timeToDecimal(using calendar: Calendar) -> Double {
        let components = calendar.dateComponents([.hour, .minute], from: self)
        let hour = components.hour ?? 0
        let minutes = components.minute ?? 0
        return Double(hour) + (Double(minutes) / 60.0)
    }
}

public extension Date {
    /// Returns the date's day as `yyyy-MM-dd` on the calendar, in ASCII digits whatever the calendar's locale.
    ///
    ///     date.shortString(calendar: calendar) // "2017-05-15"
    ///
    /// The string suits a dictionary key that groups values by day.
    func shortString(calendar: Calendar) -> String {
        DateFormatter(dateFormat: "yyyy-MM-dd", calendar: calendar, locale: .posix).string(from: self)
    }
}

public extension Date {
    /// The span that `expanding(to:using:)` widens a date to.
    enum ExpandingComponent {
        /// The week that holds the date.
        case week
        /// The month that holds the date.
        case month
        /// The month that holds the date, widened to whole weeks at both ends, as a month grid shows it.
        case monthWithTrailingWeeks
    }

    /// Returns the week or month that holds the date, or `nil` when the calendar can't find it.
    ///
    ///     // For April 1, 2020 on a Gregorian calendar whose week starts on Sunday:
    ///     date.expanding(to: .week, using: calendar) // Mar 29 through Apr 4
    ///     date.expanding(to: .month, using: calendar) // Apr 1 through Apr 30
    ///     date.expanding(to: .monthWithTrailingWeeks, using: calendar) // Mar 29 through May 2
    ///
    /// The interval's end is the first moment after its last day.
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
