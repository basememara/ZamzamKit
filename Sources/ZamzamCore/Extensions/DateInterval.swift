//
//  DateInterval.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-04-22.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSDateInterval

public extension DateInterval {
    /// Returns remaining progress between the date interval.
    var progress: (value: Double, remaining: TimeInterval) {
        progress(at: .now)
    }

    /// Returns remaining progress between the date interval at a specified date.
    func progress(at date: Date) -> (value: Double, remaining: TimeInterval) {
        guard date > start else { return (0, end.timeIntervalSince(date)) }
        guard date < end else { return (1, 0) }
        let completed = date.timeIntervalSince(start)
        return (completed / duration, duration - completed)
    }
}

public extension DateInterval {
    /// Returns dates between the range that are offset.
    /// - Parameter timeInterval: The time interval to offset the dates by.
    func stride(by timeInterval: TimeInterval) -> [Date] {
        // https://stackoverflow.com/q/68398429
        (0...Int(end.timeIntervalSince(start) / timeInterval))
            .map { start.advanced(by: TimeInterval($0) * timeInterval) }
    }
}
