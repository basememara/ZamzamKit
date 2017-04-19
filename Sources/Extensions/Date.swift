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
    var isPast: Bool {
        return compare(Date()) == .orderedAscending
    }
    
    /// Determines if date is in the future.
    var isFuture: Bool {
        return !isPast
    }
    
    /// Determines if date is in today's date.
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Gets the beginning of the day.
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// Gets the decimal representation of the time.
    var timeToDecimal: Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: self)
        let hour = components.hour
        let minutes = components.minute
        return Double(hour!) + (Double(minutes!) / 60.0)
    }
}

// MARK: - String helpers
public extension Date {
    
    init?(fromString: String, dateFormat: String = "yyyy/MM/dd HH:mm") {
        guard let date = DateFormatter(dateFormat: dateFormat).date(from: fromString),
            !fromString.isEmpty else { return nil }
        
        self.init(timeInterval: 0, since: date)
    }

    /// Returns a string representation of a given date formatted using the receiver’s current settings.
    ///
    /// - Parameter format: The date format string used by the receiver.
    /// - Returns: The string representation of the given date.
    func string(format: String, timeZone: TimeZone? = nil) -> String {
        let formatter = DateFormatter(dateFormat: format)
        
        if let timeZone = timeZone {
            formatter.timeZone = timeZone
        }
        
        return formatter.string(from: self)
    }
}

// MARK: - Calculation helpers
public extension Date {

    func increment(years: Int) -> Date {
        return Calendar.current.date(
            byAdding: .year,
            value: years,
            to: self
        )!
    }

    func increment(months: Int) -> Date {
        return Calendar.current.date(
            byAdding: .month,
            value: months,
            to: self
        )!
    }

    func increment(days: Int) -> Date {
        return Calendar.current.date(
            byAdding: .day,
            value: days,
            to: self
        )!
    }
    
    func increment(minutes: Int) -> Date {
        return Calendar.current.date(
            byAdding: .minute,
            value: minutes,
            to: self
        )!
    }
    
    func incrementDayIfPast() -> Date {
        return self.isPast ? self.increment(days: 1) : self
    }
    
    func countdown(from date: Date)  -> (span: Double, remaining: Double, percent: Double) {
        // Calculate span time
        var timeSpan = date.timeToDecimal - timeToDecimal
        if timeSpan < 0 {
            timeSpan += 24
        }
        
        // Calculate remaining times
        var timeLeft = date.timeToDecimal - Date().timeToDecimal
        if timeLeft < 0 {
            timeLeft += 24
        }
        
        // Calculate percentage
        let percentComplete = 1.0 - (timeLeft / timeSpan)
        
        return (timeSpan, timeLeft, percentComplete)
    }
    
    /**
     Specifies if the date is beyond the time window.
     
     - parameter seconds:  Time window the date is considered valid.
     - parameter fromDate: Date to use as a reference.
     
     - returns: Has the time elapsed the time window.
     */
    func hasElapsed(seconds: Int, from date: Date = Date()) -> Bool {
        return date.timeIntervalSince(self).seconds > seconds
    }
}

// MARK: - Islamic calendar
public extension Date {

    func hijriString(unit: Set<Calendar.Component>? = nil, format: String? = nil, offSet: Int = 0) -> String {
            let calendar = Calendar(identifier: .islamicCivil)
            let flags = unit ?? [.year, .month, .day, .hour, .minute, .second]
            var date = self
            
            // Handle offset if applicable
            if offSet != 0 {
                date = calendar.date(byAdding: .day,
                    value: offSet,
                    to: date
                )!
            }
            
            let components = calendar.dateComponents(flags, from: date)
            let formatter = DateFormatter()
        
            formatter.calendar = calendar
            
            if let f = format { formatter.dateFormat = f }
            else { formatter.dateStyle = .long }
            
            return formatter.string(from: calendar.date(from: components)!)
    }
    
    func hijri(offSet: Int = 0) -> DateComponents {
        let calendar = Calendar(identifier: .islamicCivil)
        var date = self
        
        // Handle offset if applicable
        if offSet != 0 {
            date = calendar.date(byAdding: .day,
                value: offSet,
                to: date
            )!
        }
        
        return calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    }
}
