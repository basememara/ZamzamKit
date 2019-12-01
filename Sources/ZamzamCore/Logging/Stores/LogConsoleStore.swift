//
//  LogConsoleStore.swift
//  ZamzamCore
//  
//
//  Created by Basem Emara on 2019-10-28.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation

/// Sends a message to the IDE console.
public struct LogConsoleStore: LogStore {
    public let minLevel: LogAPI.Level
    
    public init(minLevel: LogAPI.Level) {
        self.minLevel = minLevel
    }
}

public extension LogConsoleStore {
    
    func write(_ level: LogAPI.Level, with message: String, path: String, function: String, line: Int, context: [String: CustomStringConvertible]?) {
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
        
        print("\(prefix) \(format(message, path, function, line, context))")
    }
}
