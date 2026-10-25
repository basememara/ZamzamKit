//
//  LogServiceConsole.swift
//  ZamzamCore
//  
//  Created by Basem Emara on 2019-10-28.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSDate

/// Sends a message to the IDE console.
public struct LogServiceConsole: LogService {
    public let minLevel: LogAPI.Level
    private let subsystem: String

    public init(minLevel: LogAPI.Level, subsystem: String) {
        self.minLevel = minLevel
        self.subsystem = subsystem
    }
}

public extension LogServiceConsole {
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
