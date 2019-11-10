//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-10-28.
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
    
    func write(_ level: LogAPI.Level, with message: String, path: String, function: String, line: Int, context: [String: Any]?) {
        let prefix: String
        
        switch level {
        case .verbose:
            prefix = "💜 VERBOSE"
        case .debug:
            prefix = "💚 DEBUG"
        case .info:
            prefix = "💙 INFO"
        case .warning:
            prefix = "💛 WARNING"
        case .error:
            prefix = "❤️ ERROR"
        case .none:
            return
        }
        
        print("\(prefix) \(format(message, path, function, line, context))")
    }
}
