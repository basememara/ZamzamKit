//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public struct DateTimeHelper {
    
    public func getCurrentTimeInDecimal(date: NSDate = NSDate()) -> Double {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute],
            fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        return Double(hour) + (Double(minutes) / 60.0)
    }
    
    public func getDayOfWeek(date: NSDate = NSDate()) -> Int? {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let flags = NSCalendarUnit.Weekday
        let components = calendar?.components(flags, fromDate: date)
        return components?.weekday
    }
    
    public func incrementDay(date: NSDate = NSDate(), numberOfDays: Int = 1) -> NSDate {
        return NSCalendar.currentCalendar()
            .dateByAddingUnit(.Day,
                value: numberOfDays,
                toDate: date,
                options: NSCalendarOptions(rawValue: 0)
            )!
    }
    
    public func incrementMinutes(date: NSDate = NSDate(), numberOfMinutes: Int = 1) -> NSDate {
        return NSCalendar.currentCalendar()
            .dateByAddingUnit(.Minute,
                value: numberOfMinutes,
                toDate: date,
                options: NSCalendarOptions(rawValue: 0)
            )!
    }
    
    public func incrementDayIfPast(date: NSDate = NSDate()) -> NSDate {
        return date.compare(NSDate()) == NSComparisonResult.OrderedAscending
            ? incrementDay(date) : date
    }
    
    public func getHijriDate(var date: NSDate = NSDate(),
        unit: NSCalendarUnit? = nil,
        format: String? = nil,
        offSet: Int = 0) -> String {
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierIslamicCivil)
            let flags = unit ?? NSCalendarUnit(rawValue: UInt.max)
            
            if offSet != 0 {
                date = calendar!
                    .dateByAddingUnit(.Day,
                        value: offSet,
                        toDate: date,
                        options: NSCalendarOptions(rawValue: 0)
                    )!
            }
            
            let components = calendar?.components(flags, fromDate: date)
            
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
