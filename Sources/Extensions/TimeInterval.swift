//
//  NSTimeInterval.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/22/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension TimeInterval {
    
    /// Number of seconds to integer.
    var seconds: Int {
        return Int(self)
    }
    
    /// Convert current number of seconds to minutes.
    var minutes: Double {
        return self / 60.0
    }
    
    /// Convert current number of seconds to hours.
    var hours: Double {
        return self / 3600.0
    }
    
    /// Convert current number of seconds to days.
    var days: Double {
        return self / 86400.0
    }
    
    /// Convert current number of seconds to weeks.
    var weeks: Double {
        return self / 604800.0
    }
}

extension TimeInterval {
    
    /// Time interval unit used for date calculations
    public enum Unit {
        case seconds(Int)
        case minutes(Int)
        case hours(Int)
        case days(Int)
        case months(Int)
        case years(Int)
    }
    
    /// Time interval unit used for date calculations
    public enum UnitWithCalendar {
        case seconds(Int, Calendar)
        case minutes(Int, Calendar)
        case hours(Int, Calendar)
        case days(Int, Calendar)
        case months(Int, Calendar)
        case years(Int, Calendar)
    }
}
