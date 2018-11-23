//
//  NSDateExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Date {
    
    /// Determines if date is in the past.
    ///
    /// Uses the user's current calendar.
    ///
    ///     Date(timeIntervalSinceNow: -100).isPast -> true
    ///     Date(timeIntervalSinceNow: 100).isPast -> false
    var isPast: Bool {
        return self < Date()
    }
    
    /// Determines if date is in the future.
    ///
    /// Uses the user's current calendar.
    ///
    ///     Date(timeIntervalSinceNow: 100).isFuture -> true
    ///     Date(timeIntervalSinceNow: -100).isFuture -> false
    var isFuture: Bool {
        return self > Date()
    }
    
    /// Determines if date is in today's date.
    ///
    /// Uses the user's current calendar.
    ///
    ///     Date().isToday -> true
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Determines if date is in yesterday's date.
    ///
    /// Uses the user's current calendar.
    ///
    ///     Date(timeIntervalSinceNow: -90_000).isYesterday -> true
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// Determines if date is in tomorrow's date.
    ///
    /// Uses the user's current calendar.
    ///
    ///     Date(timeIntervalSinceNow: 90_000).isTomorrow -> true
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// Determines if date is within a weekday period.
    ///
    /// Uses the user's current calendar.
    var isWeekday: Bool {
        return !Calendar.current.isDateInWeekend(self)
    }
	
	/// Determines if date is within a weekend period.
    ///
    /// Uses the user's current calendar.
	var isWeekend: Bool {
		return Calendar.current.isDateInWeekend(self)
	}
}

public extension Date {
    
    /// Return yesterday's date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let yesterday = date.yesterday // "Oct 2, 2018, 10:57:11"
    ///
    var yesterday: Date {
        return addingTimeInterval(-86400)
    }
    
    /// Return tomorrow's date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let tomorrow = date.tomorrow // "Oct 4, 2018, 10:57:11"
    ///
    var tomorrow: Date {
        return addingTimeInterval(86400)
    }
}

public extension Date {
    
    /// Returns the beginning of the day.
    ///
    /// Uses the user's current calendar.
    ///
    ///     Date().startOfDay -> "2018/11/21 00:00:00"
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// Returns the end of the day.
    ///
    /// Uses the user's current calendar.
    ///
    ///     Date().endOfDay -> "2018/11/21 23:59:59"
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    /// Returns the beginning of the month.
    ///
    /// Uses the user's current calendar.
    ///
    ///     Date().startOfMonth -> "2018/11/01 00:00:00"
    var startOfMonth: Date {
        return Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month], from: startOfDay)
        )!
    }
    
    /// Returns the end of the month.
    ///
    /// Uses the user's current calendar.
    ///
    ///     Date().endOfMonth -> "2018/11/30 23:59:59"
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}

// MARK: - Comparisons

public extension Date {
    
    /// Determine if a date is between two other dates.
    ///
    /// Dates do not have to be in sequential order.
    ///
    ///     let date = Date()
    ///     let date1 = Date(timeIntervalSinceNow: 1000)
    ///     let date2 = Date(timeIntervalSinceNow: -1000)
    ///     date.isBetween(date1, date2) -> true
    ///
    /// - Parameters:
    ///   - date1: first date to compare to.
    ///   - date2: second date to compare to.
    /// - Returns: true if the date is between the two given dates.
    func isBetween(_ date1: Date, _ date2: Date) -> Bool {
        // https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/Extensions/Foundation/DateExtensions.swift
        return date1.compare(self).rawValue * compare(date2).rawValue > 0
    }
    
    /// Specifies if the date is beyond the time window.
    ///
    ///     let date = Date(fromString: "2016/03/22 09:40")
    ///     let fromDate = Date(fromString: "2016/03/22 09:30")
    ///
    ///     date.isBeyond(fromDate, bySeconds: 300) -> true
    ///     date.isBeyond(fromDate, bySeconds: 600) -> false
    ///     date.isBeyond(fromDate, bySeconds: 1200) -> false
    ///
    /// - Parameters:
    ///   - date: Date to use as a reference.
    ///   - seconds: Time window the date is considered valid.
    /// - Returns: Has the time elapsed the time window.
    func isBeyond(_ date: Date, bySeconds seconds: Int) -> Bool {
        return timeIntervalSince(date).seconds > seconds
    }
    
    /// Specifies if the date is beyond the time window.
    ///
    ///     let date = Date(fromString: "2016/03/22 09:40")
    ///     let fromDate = Date(fromString: "2016/03/22 09:30")
    ///
    ///     date.isBeyond(fromDate, byMinutes: 5) -> true
    ///     date.isBeyond(fromDate, byMinutes: 10) -> false
    ///     date.isBeyond(fromDate, byMinutes: 25) -> false
    ///
    /// - Parameters:
    ///   - date: Date to use as a reference.
    ///   - minutes: Time window the date is considered valid.
    /// - Returns: Has the time elapsed the time window.
    func isBeyond(_ date: Date, byMinutes minutes: Double) -> Bool {
        return timeIntervalSince(date).minutes > minutes
    }
    
    /// Specifies if the date is beyond the time window.
    ///
    ///     let date = Date(fromString: "2016/03/22 11:40")
    ///     let fromDate = Date(fromString: "2016/03/22 09:40")
    ///
    ///     date.isBeyond(fromDate, byHours: 1) -> true
    ///     date.isBeyond(fromDate, byHours: 2) -> false
    ///     date.isBeyond(fromDate, byHours: 4) -> false
    ///
    /// - Parameters:
    ///   - date: Date to use as a reference.
    ///   - hours: Time window the date is considered valid.
    /// - Returns: Has the time elapsed the time window.
    func isBeyond(_ date: Date, byHours hours: Double) -> Bool {
        return timeIntervalSince(date).hours > hours
    }
}

// MARK: - String helpers

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
    init?(fromString string: String, dateFormat: String = "yyyy/MM/dd HH:mm", timeZone: TimeZone? = nil, calendar: Calendar? = nil) {
        guard !string.isEmpty,
            let date = DateFormatter(dateFormat: dateFormat, timeZone: timeZone, calendar: calendar).date(from: string) else {
                return nil
        }
        
        self.init(timeInterval: 0, since: date)
    }
    
    /// Returns a string representation of a given date formatted using the receiver’s current settings.
    ///
    ///     Date().string(format: "MMM d, h:mm a") -> "Jan 3, 8:43 PM"
    ///
    /// - Parameters:
    ///   - format: The date format string used by the receiver.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar for the receiver.
    /// - Returns: The string representation of the given date.
    func string(format: String, timeZone: TimeZone? = nil, calendar: Calendar? = nil) -> String {
        return DateFormatter(dateFormat: format, timeZone: timeZone, calendar: calendar).string(from: self)
    }
    
    /// Returns a string representation of a given date formatted using the receiver’s current settings.
    ///
    ///     Date().string(style: .short) -> "1/12/17"
    ///     Date().string(style: .medium) -> "Jan 12, 2017"
    ///     Date().string(style: .long) -> "January 12, 2017"
    ///     Date().string(style: .full) -> "Thursday, January 12, 2017"
    ///     Date().string(style: .full, withTime: .medium) -> "Thursday, January 12, 2017 at 4:45:23 PM"
    ///
    /// - Parameters:
    ///   - dateStyle: The date style string used by the receiver.
    ///   - timeStyle: The time style string used by the receiver.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar for the receiver.
    /// - Returns: The string representation of the given date.
    func string(style dateStyle: DateFormatter.Style, withTime timeStyle: DateFormatter.Style? = nil, timeZone: TimeZone? = nil, calendar: Calendar? = nil) -> String {
        return DateFormatter(dateStyle: dateStyle, timeStyle: timeStyle, timeZone: timeZone, calendar: calendar).string(from: self)
    }
    
    /// Fixed-format for the date without time.
    ///
    /// An example use case for this function is creating a dictionary of days that group respective values by days.
    ///
    ///     Date().shortString() -> "2017-05-15"
    ///
    /// - Parameter timeZone: Time zone to determine day boundries of the date.
    /// - Returns: The formatted date string.
    func shortString(with timeZone: TimeZone? = nil) -> String {
        return DateFormatter(dateFormat: "yyyy-MM-dd", timeZone: timeZone).with {
            $0.locale = .posix
        }.string(from: self)
    }
    
    /// Formats time interval for display timer.
    ///
    ///     Date(fromString: "2016/03/22 09:45").timerString(
    ///         from: Date(fromString: "2016/03/22 09:40")
    ///     )
    ///     // Prints "00:05:00"
    ///
    /// - Parameter date: The date to countdown from.
    /// - Returns: The formatted timer as hh:mm:ss.
    func timerString(from date: Date = Date()) -> String {
        let seconds = Int(timeIntervalSince(date))
        let prefix = seconds < 0 ? "+" : ""
        let hr = abs(seconds / 3600)
        let min = abs(seconds / 60 % 60)
        let sec = abs(seconds % 60)
        return .localizedStringWithFormat("%@%02i:%02i:%02i", prefix, hr, min, sec)
    }
}

public extension Date {
    
    /// Gets the decimal representation of the time.
    ///
    ///     Date(fromString: "2012/10/23 18:15").timeToDecimal -> 18.25
    var timeToDecimal: Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: self)
        let hour = components.hour
        let minutes = components.minute
        return Double(hour!) + (Double(minutes!) / 60.0)
    }
}

// MARK: - Time zone helpers

public extension Date {

    /// Moves the date to the specified time zone.
    ///
    /// - Parameter timeZone: The target time zone.
    /// - Returns: The shifted date using the time zone.
    func shift(to timeZone: TimeZone) -> Date {
        return timeZone.isCurrent ? self : {
            let calendar: Calendar = .current
            
            var dateComponents = calendar.dateComponents(
                Calendar.Component.full,
                from: self
            )
            
            // Shift from GMT using difference of current and specified time zone
            dateComponents.second = -timeZone.offsetFromCurrent

            return calendar.date(from: dateComponents) ?? self
        }()
    }
}

// MARK: - Islamic calendar

public extension Date {

    // Cache Islamic calendar for reuse
    // https://www.staff.science.uu.nl/~gent0113/islam/ummalqura.htm
    // http://tabsir.net/?p=621#more-621
    static let islamicCalendar = Calendar(identifier: .islamicUmmAlQura)

    /// Returns a string representation of a given date formatted to hijri date.
    ///
    /// - Parameters:
    ///   - components: The components of the date to format.
    ///   - format: The date format string used by the receiver.
    ///   - offSet: The number of days to offset the hijri date.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar of the receiver.
    /// - Returns: A string representation of a given date formatted to hijri date.
    func hijriString(
        components: Set<Calendar.Component> = Calendar.Component.full,
        format: String? = nil,
        offSet: Int = 0,
        timeZone: TimeZone? = nil,
        calendar: Calendar = Date.islamicCalendar) -> String
    {
        var calendar = calendar
        if let timeZone = timeZone { calendar.timeZone = timeZone }
        
        let formatter = DateFormatter().with {
            $0.calendar = calendar
            $0.timeZone = calendar.timeZone
            if let f = format { $0.dateFormat = f }
            else { $0.dateStyle = .long }
        }
        
        let date = calendar.date(
            from: hijri(
                components: components,
                offSet: offSet,
                timeZone: timeZone,
                calendar: calendar
            )
        )!
        
        return formatter.string(from: date)
    }
    
    /// Returns the date components of the hijri date.
    ///
    /// - Parameters:
    ///   - components: The components of the date to format.
    ///   - offSet: The number of days to offset the hijri date.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar of the receiver.
    /// - Returns: The date components of the hijri date.
    func hijri(
        components: Set<Calendar.Component> = Calendar.Component.full,
        offSet: Int = 0,
        timeZone: TimeZone? = nil,
        calendar: Calendar = Date.islamicCalendar) -> DateComponents
    {
        var calendar = calendar
        
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        let date = self + .days(offSet, calendar)
        return calendar.dateComponents(components, from: date)
    }
    
    /// Determines if the date falls within Ramadan.
    ///
    /// - Parameters:
    ///   - offSet: The number of days to offset the hijri date.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar of the receiver.
    /// - Returns: True if the date is within Ramadan; false otherwise.
    func isRamadan(offSet: Int = 0, timeZone: TimeZone? = nil, calendar: Calendar = Date.islamicCalendar) -> Bool {
        return hijri(offSet: offSet, timeZone: timeZone, calendar: calendar).month == 9
    }
    
    /// Determines if the date if Friday / Jumuah.
    var isJumuah: Bool {
        return Calendar.current.dateComponents([.weekday], from: self).weekday == 6
    }
}

// MARK: - Calculations

public extension Date {
    
    static func +(left: Date, right: DateTimeInterval) -> Date {
        let calendar: Calendar = .current
        let component: Calendar.Component
        let value: Int
        
        switch right {
        case .seconds(let addValue):
            component = .second
            value = addValue
        case .minutes(let addValue):
            component = .minute
            value = addValue
        case .hours(let addValue):
            component = .hour
            value = addValue
        case .days(let addValue):
            component = .day
            value = addValue
        case .months(let addValue):
            component = .month
            value = addValue
        case .years(let addValue):
            component = .year
            value = addValue
        }
        
        guard value != 0 else { return left }
        
        return calendar.date(
            byAdding: component,
            value: value,
            to: left
        )!
    }
    
    static func -(left: Date, right: DateTimeInterval) -> Date {
        let calendar: Calendar = .current
        let component: Calendar.Component
        let value: Int
        
        switch right {
        case .seconds(let minusValue):
            component = .second
            value = minusValue
        case .minutes(let minusValue):
            component = .minute
            value = minusValue
        case .hours(let minusValue):
            component = .hour
            value = minusValue
        case .days(let minusValue):
            component = .day
            value = minusValue
        case .months(let minusValue):
            component = .month
            value = minusValue
        case .years(let minusValue):
            component = .year
            value = minusValue
        }
        
        guard value != 0 else { return left }
        
        return calendar.date(
            byAdding: component,
            value: -value,
            to: left
        )!
    }
    
    static func +(left: Date, right: DateTimeIntervalWithCalendar) -> Date {
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
        )!
    }
    
    static func -(left: Date, right: DateTimeIntervalWithCalendar) -> Date {
        let calendar: Calendar
        let component: Calendar.Component
        let value: Int
        
        switch right {
        case .seconds(let minusValue, let toCalendar):
            calendar = toCalendar
            component = .second
            value = minusValue
        case .minutes(let minusValue, let toCalendar):
            calendar = toCalendar
            component = .minute
            value = minusValue
        case .hours(let minusValue, let toCalendar):
            calendar = toCalendar
            component = .hour
            value = minusValue
        case .days(let minusValue, let toCalendar):
            calendar = toCalendar
            component = .day
            value = minusValue
        case .months(let minusValue, let toCalendar):
            calendar = toCalendar
            component = .month
            value = minusValue
        case .years(let minusValue, let toCalendar):
            calendar = toCalendar
            component = .year
            value = minusValue
        }
        
        guard value != 0 else { return left }
        
        return calendar.date(
            byAdding: component,
            value: -value,
            to: left
        )!
    }
}
