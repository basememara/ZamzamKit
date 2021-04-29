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
    /// Determines if date is in the past.
    ///
    ///     Date(timeIntervalSinceNow: -100).isPast // true
    ///     Date(timeIntervalSinceNow: 100).isPast // false
    ///
    /// Uses the user's current calendar.
    var isPast: Bool { self < Date() }

    /// Determines if date is in the future.
    ///
    ///     Date(timeIntervalSinceNow: 100).isFuture // true
    ///     Date(timeIntervalSinceNow: -100).isFuture // false
    ///
    /// Uses the user's current calendar.
    var isFuture: Bool { self > Date() }
}

public extension Date {
    /// Determines if date is in today's date.
    ///
    ///     Date().isToday // true
    ///
    /// Uses the user's current calendar.
    var isToday: Bool { isToday(using: .current) }

    /// Determines if date is in today's date.
    ///
    ///     Date().isToday(using: Calendar(identifier: .islamic)) // true
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isToday(using calendar: Calendar) -> Bool {
        calendar.isDateInToday(self)
    }
}

public extension Date {
    /// Determines if date is in yesterday's date.
    ///
    ///     Date(timeIntervalSinceNow: -90_000).isYesterday // true
    ///
    /// Uses the user's current calendar.
    var isYesterday: Bool { isYesterday(using: .current) }

    /// Determines if date is in yesterday's date.
    ///
    ///     Date(timeIntervalSinceNow: -90_000).isYesterday(using: Calendar(identifier: .islamic)) // true
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isYesterday(using calendar: Calendar) -> Bool {
        calendar.isDateInYesterday(self)
    }
}

public extension Date {
    /// Determines if date is in tomorrow's date.
    ///
    ///     Date(timeIntervalSinceNow: 90_000).isTomorrow // true
    ///
    /// Uses the user's current calendar.
    var isTomorrow: Bool { isTomorrow(using: .current) }

    /// Determines if date is in tomorrow's date.
    ///
    ///     Date(timeIntervalSinceNow: 90_000).isTomorrow(using: Calendar(identifier: .islamic)) // true
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isTomorrow(using calendar: Calendar) -> Bool {
        calendar.isDateInTomorrow(self)
    }
}

public extension Date {
    /// Determines if date is within a weekday period.
    ///
    /// Uses the user's current calendar.
    var isWeekday: Bool { isWeekday(using: .current) }

    /// Determines if date is within a weekday period.
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isWeekday(using calendar: Calendar) -> Bool {
        !calendar.isDateInWeekend(self)
    }
}

public extension Date {
	/// Determines if date is within a weekend period.
    ///
    /// Uses the user's current calendar.
	var isWeekend: Bool { isWeekend(using: .current) }

    /// Determines if date is within a weekend period.
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isWeekend(using calendar: Calendar) -> Bool {
        calendar.isDateInWeekend(self)
    }
}

public extension Date {
    /// Check if date is within the current week.
    ///
    /// Uses the user's current calendar.
    var isCurrentWeek: Bool { isCurrentWeek(using: .current) }

    /// Check if date is within the current week.
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isCurrentWeek(using calendar: Calendar) -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
}

public extension Date {
    /// Check if date is within the current month.
    ///
    /// Uses the user's current calendar.
    var isCurrentMonth: Bool { isCurrentMonth(using: .current) }

    /// Check if date is within the current month.
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isCurrentMonth(using calendar: Calendar) -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }
}

public extension Date {
    /// Check if date is within the current year.
    ///
    /// Uses the user's current calendar.
    var isCurrentYear: Bool { isCurrentYear(using: .current) }

    /// Check if date is within the current year.
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isCurrentYear(using calendar: Calendar) -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }
}

public extension Date {
    /// Return yesterday's date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let yesterday = date.yesterday // "Oct 2, 2018, 10:57:11"
    ///
    /// Uses the user's current calendar.
    var yesterday: Date { yesterday(using: .current) }

    /// Return yesterday's date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let yesterday = date.yesterday // "Oct 2, 2018, 10:57:11"
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
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let tomorrow = date.tomorrow // "Oct 4, 2018, 10:57:11"
    ///
    /// Uses the user's current calendar.
    var tomorrow: Date { tomorrow(using: .current) }

    /// Return tomorrow's date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let tomorrow = date.tomorrow // "Oct 4, 2018, 10:57:11"
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
    ///     Date().startOfDay // "2018/11/21 00:00:00"
    ///
    /// Uses the user's current calendar.
    var startOfDay: Date { startOfDay(using: .current) }

    /// Returns the beginning of the day.
    ///
    ///     Date().startOfDay // "2018/11/21 00:00:00"
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
    ///     Date().endOfDay // "2018/11/21 23:59:59"
    ///
    /// Uses the user's current calendar.
    var endOfDay: Date { endOfDay(using: .current) }

    /// Returns the end of the day.
    ///
    ///     Date().endOfDay // "2018/11/21 23:59:59"
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
    ///     Date().startOfMonth // "2018/11/01 00:00:00"
    ///
    /// Uses the user's current calendar.
    var startOfMonth: Date { startOfMonth(using: .current) }

    /// Returns the beginning of the month.
    ///
    ///     Date().startOfMonth // "2018/11/01 00:00:00"
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
    ///     Date().endOfMonth // "2018/11/30 23:59:59"
    ///
    /// Uses the user's current calendar.
    var endOfMonth: Date { endOfMonth(using: .current) }

    /// Returns the end of the month.
    ///
    ///     Date().endOfMonth // "2018/11/30 23:59:59"
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
    ///     Date(fromString: "2012/10/23 18:15").timeToDecimal // 18.25
    var timeToDecimal: Double { timeToDecimal(using: .current) }

    /// Gets the decimal representation of the time.
    ///
    ///     Date(fromString: "2012/10/23 18:15").timeToDecimal // 18.25
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func timeToDecimal(using calendar: Calendar) -> Double {
        let components = calendar.dateComponents([.hour, .minute], from: self)
        let hour = components.hour ?? 0
        let minutes = components.minute ?? 0
        return Double(hour) + (Double(minutes) / 60.0)
    }
}
