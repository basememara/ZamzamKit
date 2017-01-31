//
//  NSTimeInterval.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/22/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension TimeInterval {
    
    var seconds: Int {
        return Int(self)
    }
    
    var minutes: Double {
        return self / 60.0
    }
    
    var hours: Double {
        return self / 3600.0
    }
    
    var days: Double {
        return self / 86400.0
    }
    
    var weeks: Double {
        return self / 604800.0
    }
    
    /**
     Delays a process via GCD based after the time interval value.
     http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861

     - parameter thread:  Thread to execute the delay on.
     - parameter handler: Process to execute after the time interval seconds.
     */
    func delay(_ thread: DispatchQueue = DispatchQueue.global(qos: .background), execute: @escaping () -> ()) {
        thread.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(self * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: execute
        )
    }
    
}
