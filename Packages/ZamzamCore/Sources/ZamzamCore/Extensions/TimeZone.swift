//
//  TimeZone.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation

public extension TimeZone {
    
    /// Unix representation of time zone usually used for normalizing.
    static let posix = TimeZone(identifier: "GMT")
}

public extension TimeZone {

    /// Determines if the time zone is the current time zone of the device.
    ///
    ///     let timeZone = TimeZone(identifier: "Europe/Paris")
    ///     timeZone?.isCurrent -> false
    var isCurrent: Bool {
        return TimeZone.current.secondsFromGMT() == secondsFromGMT()
    }
    
    /// The difference in seconds between the specified time zone and the current time zone of the device.
    ///
    ///     let timeZone = TimeZone(identifier: "Europe/Paris")
    ///     timeZone?.offsetFromCurrent -> -21600
    var offsetFromCurrent: Int {
        return TimeZone.current.secondsFromGMT() - secondsFromGMT()
    }
}
