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
