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

    public init(minLevel: LogAPI.Level) {
        self.minLevel = minLevel
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
        context: [String: CustomStringConvertible]
    ) {
        let prefix: String

        switch level {
        case .verbose:
            prefix = "💜 \(timestamp: Date()) VERBOSE"
        case .debug:
            prefix = "💚 \(timestamp: Date()) DEBUG"
        case .info:
            prefix = "💙 \(timestamp: Date()) INFO"
        case .warning:
            prefix = "💛 \(timestamp: Date()) WARNING"
        case .error:
            prefix = "❤️ \(timestamp: Date()) ERROR"
        case .none:
            return
        }

        print("\(prefix) \(format(message, file, function, line, error, context))")
    }
}
