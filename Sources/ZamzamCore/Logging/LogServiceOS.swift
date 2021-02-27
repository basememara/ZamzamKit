//
//  LogServiceOS.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-11-01.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import os

/// Sends a message to the logging system, optionally specifying a custom log object, log level, and any message format arguments.
public struct LogServiceOS: LogService {
    public let minLevel: LogAPI.Level
    private let subsystem: String
    private let category: String
    private let log: OSLog

    public init(minLevel: LogAPI.Level, subsystem: String, category: String) {
        self.minLevel = minLevel
        self.subsystem = subsystem
        self.category = category
        self.log = OSLog(subsystem: subsystem, category: category)
    }
}

public extension LogServiceOS {

    func write(
        _ level: LogAPI.Level,
        with message: String,
        file: String,
        function: String,
        line: Int,
        error: Error?,
        context: [String: CustomStringConvertible]
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

        os_log("%@", log: log, type: type, format(message, file, function, line, error, context))
    }
}
