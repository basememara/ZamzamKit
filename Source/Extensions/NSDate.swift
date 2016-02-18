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
        return self.compare(NSDate()) == .OrderedAscending
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
    
}