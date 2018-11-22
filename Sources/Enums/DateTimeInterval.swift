//
//  DateTimeInterval.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2018-11-22.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import Foundation

/// Represents a specified number of a calendar component unit. You use `DateTimeInterval` values to do date calculations.
public enum DateTimeInterval {
    case seconds(Int)
    case minutes(Int)
    case hours(Int)
    case days(Int)
    case months(Int)
    case years(Int)
}

/// Represents a specified number of a calendar component unit for a calendar. You use `DateTimeIntervalWithCalendar` values to do date calculations.
public enum DateTimeIntervalWithCalendar {
    case seconds(Int, Calendar)
    case minutes(Int, Calendar)
    case hours(Int, Calendar)
    case days(Int, Calendar)
    case months(Int, Calendar)
    case years(Int, Calendar)
}
