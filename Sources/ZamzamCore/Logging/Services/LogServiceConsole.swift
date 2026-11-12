//
//  LogServiceConsole.swift
//  ZamzamCore
//  
//  Created by Basem Emara on 2019-10-28.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSDate

/// Prints each entry to standard output, which Xcode shows in its console.
public struct LogServiceConsole: LogService {
    /// The lowest level this service writes.
    public let minLevel: LogAPI.Level
    private let subsystem: String

    /// Creates a console destination. `subsystem` is printed in brackets on each entry.
    public init(minLevel: LogAPI.Level, subsystem: String) {
        self.minLevel = minLevel
        self.subsystem = subsystem
    }
}

public extension LogServiceConsole {
    /// Prints the entry after a heart colored for its level, the time, the level's name and the subsystem.
    /// The session context is left out.
    func write(
        _ level: LogAPI.Level,
        with message: String,
        file: String,
        function: String,
        line: Int,
        error: Error?,
        context: [String: any CustomStringConvertible & Sendable],
        sessionContext: [String: any CustomStringConvertible & Sendable]
    ) {
        let time = Date.now.formatted(.dateTime.hour(.twoDigits(amPM: .omitted)).minute().second().secondFraction(.fractional(3)))

        guard let prefix = level.prefix(time: time, subsystem: subsystem) else { return }

        print("\(prefix) \(format(message, file, function, line, error, context))")
    }
}
