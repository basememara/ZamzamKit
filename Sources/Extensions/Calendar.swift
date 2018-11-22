//
//  Calendar.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

public extension Calendar {
    
    /// Normalize date calculations using Gregorian calendar with UTC timezone and POSIX.
    static let gregorianUTC: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        calendar.locale = .posix
        return calendar
    }()
}

public extension Calendar.Component {
    
    /// The set component units of date that includes year, month, day, hour, minute, and second
    static let full: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
}

public extension Calendar.Component {
    
    /// Value type used for date calculations
    enum Value {
        case seconds(Int)
        case minutes(Int)
        case hours(Int)
        case days(Int)
        case months(Int)
        case years(Int)
    }
    
    /// Value type with calendar used for date calculations
    enum ValueWithCalendar {
        case seconds(Int, Calendar)
        case minutes(Int, Calendar)
        case hours(Int, Calendar)
        case days(Int, Calendar)
        case months(Int, Calendar)
        case years(Int, Calendar)
    }
}
