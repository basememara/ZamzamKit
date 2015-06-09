//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public class DateTimeService: NSObject {
    
    public func getCurrentTimeInDecimal(date: NSDate = NSDate()) -> Double {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute,
            fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        return Double(hour) + (Double(minutes) / 60.0)
    }
    
    public func getDayOfWeek(date: NSDate = NSDate()) -> Int? {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let flags = NSCalendarUnit.CalendarUnitWeekday
        let components = calendar?.components(flags, fromDate: date)
        return components?.weekday
    }
    
    public func incrementDay(_ date: NSDate = NSDate(), numberOfDays: Int = 1) -> NSDate {
        return NSCalendar.currentCalendar()
            .dateByAddingUnit(.CalendarUnitDay,
                value: numberOfDays,
                toDate: date,
                options: NSCalendarOptions(0)
            )!
    }
    
    public func incrementMinutes(_ date: NSDate = NSDate(), numberOfMinutes: Int = 1) -> NSDate {
        return NSCalendar.currentCalendar()
            .dateByAddingUnit(.CalendarUnitMinute,
                value: numberOfMinutes,
                toDate: date,
                options: NSCalendarOptions(0)
            )!
    }
    
    public func incrementDayIfPast(_ date: NSDate = NSDate()) -> NSDate {
        return date.compare(NSDate()) == NSComparisonResult.OrderedAscending
            ? incrementDay(date) : date
    }
    
    public func getHijriDate(date: NSDate = NSDate(),
        unit: NSCalendarUnit? = nil,
        format: String? = nil) -> String {
            var calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierIslamicCivil)
            var flags = unit ?? NSCalendarUnit(UInt.max)
            var components = calendar?.components(flags, fromDate: date)
            
            let formatter = NSDateFormatter()
            if let f = format {
                formatter.dateFormat = f
            } else {
                formatter.dateStyle = .LongStyle
            }
            formatter.calendar = calendar
            
            return formatter.stringFromDate(calendar!.dateFromComponents(components!)!)
    }
    
}
