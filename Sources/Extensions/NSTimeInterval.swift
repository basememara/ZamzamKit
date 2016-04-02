//
//  NSTimeInterval.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/22/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension NSTimeInterval {
    
    public var seconds: Int {
        return Int(self)
    }
    
    public var minutes: Double {
        return self / 60.0
    }
    
    public var hours: Double {
        return self / 3600.0
    }
    
    public var days: Double {
        return self / 86400.0
    }
    
    public var weeks: Double {
        return self / 604800.0
    }
    
    /**
     Delays a process via GCD based after the time interval value.

     - parameter handler: Process to execute after the time interval seconds.
     */
    public func delay(handler: () -> ()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(self * Double(NSEC_PER_SEC))
            ),
            dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), handler)
    }
    
}