//
//  LogConsoleService.swift
//  ZamzamCore
//  
//
//  Created by Basem Emara on 2019-10-28.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSDate

/// Sends a message to the IDE console.
public struct LogConsoleService: LogService {
    public let minLevel: LogAPI.Level
    
    public init(minLevel: LogAPI.Level) {
        self.minLevel = minLevel
    }
}

public extension LogConsoleService {
    
    func write(_ level: LogAPI.Level, with message: String, path: String, function: String, line: Int, error: Error?, context: [String: CustomStringConvertible]?) {
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
        
        print("\(prefix) \(format(message, path, function, line, error, context))")
    }
}
