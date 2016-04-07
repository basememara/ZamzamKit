//
//  NSDateExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension NSDate {
    
    public convenience init?(fromString: String, dateFormat: String = "yyyy/MM/dd HH:mm") {
        guard let date = NSDateFormatter(dateFormat: dateFormat).dateFromString(fromString)
            where !fromString.isEmpty else {
                return nil
        }
        
        self.init(timeInterval: 0, sinceDate: date)
    }
    
    public func isPast() -> Bool {
        return self.compare(NSDate()) == .OrderedAscending
    }
    
    public func isFuture() -> Bool {
        return !self.isPast()
    }
    
    public func incrementDay(numberOfDays: Int = 1) -> NSDate {
        return NSCalendar.currentCalendar()
            .dateByAddingUnit(.Day,
                value: numberOfDays,
                toDate: self,
                options: NSCalendarOptions(rawValue: 0)
            )!
    }
    
    public func incrementMinutes(numberOfMinutes: Int = 1) -> NSDate {
        return NSCalendar.currentCalendar()
            .dateByAddingUnit(.Minute,
                value: numberOfMinutes,
                toDate: self,
                options: NSCalendarOptions(rawValue: 0)
            )!
    }
    
    public func incrementDayIfPast() -> NSDate {
        return self.isPast()
            ? self.incrementDay() : self
    }
    
    public func timeToDecimal() -> Double {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute],
            fromDate: self)
        let hour = components.hour
        let minutes = components.minute
        return Double(hour) + (Double(minutes) / 60.0)
    }
    
    public func toHijriString(
        unit: NSCalendarUnit? = nil,
        format: String? = nil,
        offSet: Int = 0) -> String {
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierIslamicCivil)!
            let flags = unit ?? NSCalendarUnit(rawValue: UInt.max)
            var date = self.copy() as! NSDate
            
            // Handle offset if applicable
            if offSet != 0 {
                date = calendar
                    .dateByAddingUnit(.Day,
                        value: offSet,
                        toDate: date,
                        options: NSCalendarOptions(rawValue: 0)
                    )!
            }
            
            let components = calendar.components(flags, fromDate: date)
            
            let formatter = NSDateFormatter()
            if let f = format {
                formatter.dateFormat = f
            } else {
                formatter.dateStyle = .LongStyle
            }
            formatter.calendar = calendar
            
            return formatter.stringFromDate(calendar.dateFromComponents(components)!)
    }
    
    public func countdown(date: NSDate)  -> (span: Double, remaining: Double, percent: Double) {
        // Calculate span time
        var timeSpan = date.timeToDecimal() - self.timeToDecimal()
        if timeSpan < 0 {
            timeSpan += 24
        }
        
        // Calculate remaining times
        var timeLeft = date.timeToDecimal() - NSDate().timeToDecimal()
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
    public func hasElapsed(seconds: Int, fromDate: NSDate = NSDate()) -> Bool {
        return fromDate.timeIntervalSinceDate(self).seconds > seconds
    }
    
}