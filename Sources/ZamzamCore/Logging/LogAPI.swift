//
//  LogAPI.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-06-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation

// Namespace
public enum LogAPI {}

public protocol LogStore: AppInfo {
    
    /// The minimum level required to create log entries.
    var minLevel: LogAPI.Level { get }
    
    /// Log an entry to the destination.
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    func write(_ level: LogAPI.Level, with message: String, path: String, function: String, line: Int, context: [String: Any]?)
    
    /// Returns if the logger should process the entry for the specified log level.
    func canWrite(for level: LogAPI.Level) -> Bool
    
    /// The output of the message and supporting information.
    /// - Parameters:
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    func format(_ message: String, _ path: String, _ function: String, _ line: Int, _ context: [String: Any]?) -> String
}

public extension LogStore {
    
    func canWrite(for level: LogAPI.Level) -> Bool {
        minLevel <= level && level != .none
    }
    
    func format(_ message: String, _ path: String, _ function: String, _ line: Int, _ context: [String: Any]?) -> String {
        "\(URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent).\(function):\(line) - \(message)"
    }
}

public protocol LogWorkerType {
    
    /// Log an entry to the destination.
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func write(_ level: LogAPI.Level, with message: String, path: String, function: String, line: Int, context: [String: Any]?, completion: (() -> Void)?)
    
    /// Log something generally unimportant (lowest priority; not written to file)
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func verbose(_ message: String, path: String, function: String, line: Int, context: [String: Any]?, completion: (() -> Void)?)
    
    /// Log something which help during debugging (low priority; not written to file)
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func debug(_ message: String, path: String, function: String, line: Int, context: [String: Any]?, completion: (() -> Void)?)
    
    /// Log something which you are really interested but which is not an issue or error (normal priority)
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func info(_ message: String, path: String, function: String, line: Int, context: [String: Any]?, completion: (() -> Void)?)
    
    /// Log something which may cause big trouble soon (high priority)
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func warning(_ message: String, path: String, function: String, line: Int, context: [String: Any]?, completion: (() -> Void)?)
    
    /// Log something which will keep you awake at night (highest priority)
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.   
    func error(_ message: String, path: String, function: String, line: Int, context: [String: Any]?, completion: (() -> Void)?)
}

public extension LogWorkerType {
    
    /// Log something generally unimportant (lowest priority; not written to file)
    func verbose(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil, completion: (() -> Void)? = nil) {
        write(.verbose, with: message, path: path, function: function, line: line, context: context, completion: completion)
    }
    
    /// Log something which help during debugging (low priority; not written to file)
    func debug(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil, completion: (() -> Void)? = nil) {
        write(.debug, with: message, path: path, function: function, line: line, context: context, completion: completion)
    }
    
    /// Log something which you are really interested but which is not an issue or error (normal priority)
    func info(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil, completion: (() -> Void)? = nil) {
        write(.info, with: message, path: path, function: function, line: line, context: context, completion: completion)
    }
    
    /// Log something which may cause big trouble soon (high priority)
    func warning(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil, completion: (() -> Void)? = nil) {
        write(.warning, with: message, path: path, function: function, line: line, context: context, completion: completion)
    }
    
    /// Log something which will keep you awake at night (highest priority)
    func error(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil, completion: (() -> Void)? = nil) {
        write(.error, with: message, path: path, function: function, line: line, context: context, completion: completion)
    }
}

// MARK: - Types

public extension LogAPI {
    
    enum Level: Int, Comparable, CaseIterable {
        case verbose
        case debug
        case info
        case warning
        case error
        
        /// Disables a log store when used as minimum level
        case none = 99
        
        public static func < (lhs: Level, rhs: Level) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
}
