//
//  LogServiceOS.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-11-01.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import os

/// Writes each entry to the unified logging system, which the Console app reads.
public struct LogServiceOS: LogService {
    /// The lowest level this service writes.
    public let minLevel: LogAPI.Level
    private let subsystem: String
    private let category: String
    private let log: OSLog
    private let isDebug: Bool

    /// Creates a system log destination.
    ///
    /// - Parameter isDebug: `true` logs the text as public, so Console shows it in full, and leaves out the session
    ///   context. `false` logs the text with the system's default privacy and adds the session context.
    public init(minLevel: LogAPI.Level, subsystem: String, category: String, isDebug: Bool) {
        self.minLevel = minLevel
        self.subsystem = subsystem
        self.category = category
        self.log = OSLog(subsystem: subsystem, category: category)
        self.isDebug = isDebug
    }
}

public extension LogServiceOS {
    /// Writes the entry as `debug` for verbose and debug, `info` for info, `default` for a warning and `error` for an error.
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
        let type: OSLogType

        switch level {
        case .verbose:
            type = .debug
        case .debug:
            type = .debug
        case .info:
            type = .info
        case .warning:
            type = .default
        case .error:
            type = .error
        case .none:
            return
        }

        // Expose message in Console app if debug mode
        if isDebug {
            os_log("%{public}s", log: log, type: type, format(message, file, function, line, error, context))
            return
        }

        os_log("%@", log: log, type: type, format(message, file, function, line, error, sessionContext.merging(context) { $1 }))
    }
}
