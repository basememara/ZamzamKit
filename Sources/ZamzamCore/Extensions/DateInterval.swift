//
//  DateInterval.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-04-22.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSDateInterval

public extension DateInterval {
    /// Returns how far the date is through the interval, from 0 to 1, and the seconds left until the end.
    ///
    /// Before the start the value is 0 and the remaining time runs from the date to the end. At or after the end the
    /// result is `(1, 0)`.
    func progress(at date: Date) -> (value: Double, remaining: TimeInterval) {
        guard date > start else { return (0, end.timeIntervalSince(date)) }
        guard date < end else { return (1, 0) }
        let completed = date.timeIntervalSince(start)
        return (completed / duration, duration - completed)
    }
}

public extension DateInterval {
    /// Returns the dates from the start, one every `timeInterval` seconds, up to the end, which is included when a
    /// step lands on it.
    ///
    /// - Parameter timeInterval: The seconds between dates. One that isn't positive, or is too small for its dates to be
    ///   counted, gives no dates.
    func stride(by timeInterval: TimeInterval) -> [Date] {
        // https://stackoverflow.com/q/68398429
        guard timeInterval > 0,
              let steps = Int(exactly: (end.timeIntervalSince(start) / timeInterval).rounded(.towardZero))
        else {
            return []
        }

        return (0...steps).map { start.advanced(by: TimeInterval($0) * timeInterval) }
    }
}
