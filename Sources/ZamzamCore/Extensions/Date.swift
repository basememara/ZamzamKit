//
//  Date.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation

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
    var isToday: Bool { isToday(for: .current) }
    
    /// Determines if date is in today's date.
    ///
    ///     Date().isToday(for: Calendar(identifier: .islamic)) // true
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isToday(for calendar: Calendar) -> Bool {
        calendar.isDateInToday(self)
    }
}

public extension Date {
    
    /// Determines if date is in yesterday's date.
    ///
    ///     Date(timeIntervalSinceNow: -90_000).isYesterday // true
    ///
    /// Uses the user's current calendar.
    var isYesterday: Bool { isYesterday(for: .current) }
    
    /// Determines if date is in yesterday's date.
    ///
    ///     Date(timeIntervalSinceNow: -90_000).isYesterday(for: Calendar(identifier: .islamic)) // true
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isYesterday(for calendar: Calendar) -> Bool {
        calendar.isDateInYesterday(self)
    }
}

public extension Date {
    
    /// Determines if date is in tomorrow's date.
    ///
    ///     Date(timeIntervalSinceNow: 90_000).isTomorrow // true
    ///
    /// Uses the user's current calendar.
    var isTomorrow: Bool { isTomorrow(for: .current) }
    
    /// Determines if date is in tomorrow's date.
    ///
    ///     Date(timeIntervalSinceNow: 90_000).isTomorrow(for: Calendar(identifier: .islamic)) // true
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isTomorrow(for calendar: Calendar) -> Bool {
        calendar.isDateInTomorrow(self)
    }
}

public extension Date {
    
    /// Determines if date is within a weekday period.
    ///
    /// Uses the user's current calendar.
    var isWeekday: Bool { isWeekday(for: .current) }
    
    /// Determines if date is within a weekday period.
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isWeekday(for calendar: Calendar) -> Bool {
        !calendar.isDateInWeekend(self)
    }
}

public extension Date {
	
	/// Determines if date is within a weekend period.
    ///
    /// Uses the user's current calendar.
	var isWeekend: Bool { isWeekend(for: .current) }
    
    /// Determines if date is within a weekend period.
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isWeekend(for calendar: Calendar) -> Bool {
        calendar.isDateInWeekend(self)
    }
}

public extension Date {
    
    /// Check if date is within the current week.
    ///
    /// Uses the user's current calendar.
    var isCurrentWeek: Bool { isCurrentWeek(for: .current) }
    
    /// Check if date is within the current week.
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isCurrentWeek(for calendar: Calendar) -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
}

public extension Date {
    
    /// Check if date is within the current month.
    ///
    /// Uses the user's current calendar.
    var isCurrentMonth: Bool { isCurrentMonth(for: .current) }
    
    /// Check if date is within the current month.
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isCurrentMonth(for calendar: Calendar) -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }
}

public extension Date {
    
    /// Check if date is within the current year.
    ///
    /// Uses the user's current calendar.
    var isCurrentYear: Bool { isCurrentYear(for: .current) }
    
    /// Check if date is within the current year.
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isCurrentYear(for calendar: Calendar) -> Bool {
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
    var yesterday: Date { yesterday(for: .current) }
    
    /// Return yesterday's date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let yesterday = date.yesterday // "Oct 2, 2018, 10:57:11"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func yesterday(for calendar: Calendar) -> Date {
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
    var tomorrow: Date { tomorrow(for: .current) }
    
    /// Return tomorrow's date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let tomorrow = date.tomorrow // "Oct 4, 2018, 10:57:11"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func tomorrow(for calendar: Calendar) -> Date {
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
    var startOfDay: Date { startOfDay(for: .current) }
    
    /// Returns the beginning of the day.
    ///
    ///     Date().startOfDay // "2018/11/21 00:00:00"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func startOfDay(for calendar: Calendar) -> Date {
        calendar.startOfDay(for: self)
    }
}

public extension Date {
    
    /// Returns the end of the day.
    ///
    ///     Date().endOfDay // "2018/11/21 23:59:59"
    ///
    /// Uses the user's current calendar.
    var endOfDay: Date { endOfDay(for: .current) }
    
    /// Returns the end of the day.
    ///
    ///     Date().endOfDay // "2018/11/21 23:59:59"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func endOfDay(for calendar: Calendar) -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        
        return calendar.date(
            byAdding: components,
            to: startOfDay(for: calendar)
        ) ?? self
    }
}

public extension Date {
    
    /// Returns the beginning of the month.
    ///
    ///     Date().startOfMonth // "2018/11/01 00:00:00"
    ///
    /// Uses the user's current calendar.
    var startOfMonth: Date { startOfMonth(for: .current) }
    
    /// Returns the beginning of the month.
    ///
    ///     Date().startOfMonth // "2018/11/01 00:00:00"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func startOfMonth(for calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: startOfDay(for: calendar))
        ) ?? self
    }
}

public extension Date {
    
    /// Returns the end of the month.
    ///
    ///     Date().endOfMonth // "2018/11/30 23:59:59"
    ///
    /// Uses the user's current calendar.
    var endOfMonth: Date { endOfMonth(for: .current) }
    
    /// Returns the end of the month.
    ///
    ///     Date().endOfMonth // "2018/11/30 23:59:59"
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func endOfMonth(for calendar: Calendar) -> Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        
        return calendar.date(
            byAdding: components,
            to: startOfMonth(for: calendar)
        ) ?? self
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
    ///     date.isBetween(date1, date2) // true
    ///
    /// - Parameters:
    ///   - date1: first date to compare to.
    ///   - date2: second date to compare to.
    /// - Returns: true if the date is between the two given dates.
    func isBetween(_ date1: Date, _ date2: Date) -> Bool {
        // https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/Extensions/Foundation/DateExtensions.swift
        date1.compare(self).rawValue * compare(date2).rawValue > 0
    }
    
    /// Specifies if the date is beyond the time window.
    ///
    ///     let date = Date(fromString: "2016/03/22 09:40")
    ///     let fromDate = Date(fromString: "2016/03/22 09:30")
    ///
    ///     date.isBeyond(fromDate, bySeconds: 300) // true
    ///     date.isBeyond(fromDate, bySeconds: 600) // false
    ///     date.isBeyond(fromDate, bySeconds: 1200) // false
    ///
    /// - Parameters:
    ///   - date: Date to use as a reference.
    ///   - seconds: Time window the date is considered valid.
    /// - Returns: Has the time elapsed the time window.
    func isBeyond(_ date: Date, bySeconds seconds: Int) -> Bool {
        timeIntervalSince(date).seconds > seconds
    }
    
    /// Specifies if the date is beyond the time window.
    ///
    ///     let date = Date(fromString: "2016/03/22 09:40")
    ///     let fromDate = Date(fromString: "2016/03/22 09:30")
    ///
    ///     date.isBeyond(fromDate, byMinutes: 5) // true
    ///     date.isBeyond(fromDate, byMinutes: 10) // false
    ///     date.isBeyond(fromDate, byMinutes: 25) // false
    ///
    /// - Parameters:
    ///   - date: Date to use as a reference.
    ///   - minutes: Time window the date is considered valid.
    /// - Returns: Has the time elapsed the time window.
    func isBeyond(_ date: Date, byMinutes minutes: Double) -> Bool {
        timeIntervalSince(date).minutes > minutes
    }
    
    /// Specifies if the date is beyond the time window.
    ///
    ///     let date = Date(fromString: "2016/03/22 11:40")
    ///     let fromDate = Date(fromString: "2016/03/22 09:40")
    ///
    ///     date.isBeyond(fromDate, byHours: 1) // true
    ///     date.isBeyond(fromDate, byHours: 2) // false
    ///     date.isBeyond(fromDate, byHours: 4) // false
    ///
    /// - Parameters:
    ///   - date: Date to use as a reference.
    ///   - hours: Time window the date is considered valid.
    /// - Returns: Has the time elapsed the time window.
    func isBeyond(_ date: Date, byHours hours: Double) -> Bool {
        timeIntervalSince(date).hours > hours
    }
    
    /// Specifies if the date is beyond the time window.
    ///
    ///     let date = Date(fromString: "2016/03/24 11:40")
    ///     let fromDate = Date(fromString: "2016/03/22 09:40")
    ///
    ///     date.isBeyond(fromDate, byDays: 1) // true
    ///     date.isBeyond(fromDate, byDays: 2) // true
    ///     date.isBeyond(fromDate, byDays: 3) // false
    ///
    /// - Parameters:
    ///   - date: Date to use as a reference.
    ///   - days: Time window the date is considered valid.
    /// - Returns: Has the time elapsed the time window.
    func isBeyond(_ date: Date, byDays days: Double) -> Bool {
        timeIntervalSince(date).days > days
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
    ///   - locale: The locale for the receiver.
    init?(fromString string: String, dateFormat: String = "yyyy/MM/dd HH:mm", timeZone: TimeZone? = nil, calendar: Calendar? = nil, locale: Locale? = nil) {
        guard !string.isEmpty,
            let date = DateFormatter(dateFormat: dateFormat, timeZone: timeZone, calendar: calendar, locale: locale).date(from: string) else {
                return nil
        }
        
        self.init(timeInterval: 0, since: date)
    }
    
    /// Returns a string representation of a given date formatted using the receiver’s current settings.
    ///
    ///     Date().string(format: "MMM d, h:mm a") // "Jan 3, 8:43 PM"
    ///
    /// - Parameters:
    ///   - format: The date format string used by the receiver.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar for the receiver.
    ///   - locale: The locale for the receiver.
    /// - Returns: The string representation of the given date.
    func string(format: String, timeZone: TimeZone? = nil, calendar: Calendar? = nil, locale: Locale? = nil) -> String {
        DateFormatter(dateFormat: format, timeZone: timeZone, calendar: calendar, locale: locale).string(from: self)
    }
    
    /// Returns a string representation of a given date formatted using the receiver’s current settings.
    ///
    ///     Date().string(style: .short) // "1/12/17"
    ///     Date().string(style: .medium) // "Jan 12, 2017"
    ///     Date().string(style: .long) // "January 12, 2017"
    ///     Date().string(style: .full) // "Thursday, January 12, 2017"
    ///     Date().string(style: .full, withTime: .medium) // "Thursday, January 12, 2017 at 4:45:23 PM"
    ///
    /// - Parameters:
    ///   - dateStyle: The date style string used by the receiver.
    ///   - timeStyle: The time style string used by the receiver.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar for the receiver.
    ///   - locale: The locale for the receiver.
    /// - Returns: The string representation of the given date.
    func string(style dateStyle: DateFormatter.Style, withTime timeStyle: DateFormatter.Style? = nil, timeZone: TimeZone? = nil, calendar: Calendar? = nil, locale: Locale? = nil) -> String {
        DateFormatter(dateStyle: dateStyle, timeStyle: timeStyle, timeZone: timeZone, calendar: calendar, locale: locale).string(from: self)
    }
    
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
    
    /// Formats time interval for display timer.
    ///
    ///     Date(fromString: "2016/03/22 09:45").timerString(
    ///         from: Date(fromString: "2016/03/22 09:40")
    ///     ) // "00:05:00"
    ///
    /// - Parameter
    ///   - date: The date to countdown from.
    ///   - positivePrefix: THe prefix string to prepend to the timer.
    /// - Returns: The formatted timer as hh:mm:ss.
    func timerString(from date: Date = Date(), positivePrefix: String = "+") -> String {
        let seconds = Int(timeIntervalSince(date))
        let prefix = seconds < 0 ? positivePrefix : ""
        let hr = abs(seconds / 3600)
        let min = abs(seconds / 60 % 60)
        let sec = abs(seconds % 60)
        return .localizedStringWithFormat("%@%02i:%02i:%02i", prefix, hr, min, sec)
    }
}

public extension Date {
    
    /// Gets the decimal representation of the time.
    ///
    ///     Date(fromString: "2012/10/23 18:15").timeToDecimal // 18.25
    var timeToDecimal: Double { timeToDecimal(for: .current) }
    
    /// Gets the decimal representation of the time.
    ///
    ///     Date(fromString: "2012/10/23 18:15").timeToDecimal // 18.25
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns the date.
    func timeToDecimal(for calendar: Calendar) -> Double {
        let components = calendar.dateComponents([.hour, .minute], from: self)
        let hour = components.hour ?? 0
        let minutes = components.minute ?? 0
        return Double(hour) + (Double(minutes) / 60.0)
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
        calendar: Calendar = Self.islamicCalendar
    ) -> String {
        var calendar = calendar
        
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        let formatter = DateFormatter().with {
            $0.calendar = calendar
            $0.timeZone = calendar.timeZone
            
            if let f = format {
                $0.dateFormat = f
            } else {
                $0.dateStyle = .long
            }
        }
        
        let date = calendar.date(
            from: hijri(
                components: components,
                offSet: offSet,
                timeZone: timeZone,
                calendar: calendar
            )
        ) ?? self
        
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
        calendar: Calendar = Self.islamicCalendar
    ) -> DateComponents {
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
    func isRamadan(offSet: Int = 0, timeZone: TimeZone? = nil, calendar: Calendar = Self.islamicCalendar) -> Bool {
        hijri(offSet: offSet, timeZone: timeZone, calendar: calendar).month == 9
    }
    
    /// Determines if the date if Friday / Jumuah.
    var isJumuah: Bool { isJumuah(for: .current) }
    
    /// Determines if the date if Friday / Jumuah.
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isJumuah(for calendar: Calendar) -> Bool {
        calendar.dateComponents([.weekday], from: self).weekday == 6
    }
}

private extension Date {
    //swiftlint:disable file_length
}
