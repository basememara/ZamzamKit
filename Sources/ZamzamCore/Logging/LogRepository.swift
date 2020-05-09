//
//  LogRepository.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-06-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation

public struct LogRepository {
    private let services: [LogService]
    
    public init(services: [LogService]) {
        self.services = services
    }
}

public extension LogRepository {
    
    /// Log an entry to the destination.
    ///
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - error: Error of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func write(_ level: LogAPI.Level, with message: String, path: String, function: String, line: Int, error: Error?, context: [String: CustomStringConvertible]?, completion: (() -> Void)?) {
        let destinations = services.filter { $0.canWrite(for: level) }
        
        // Skip if does not meet minimum log level
        guard !destinations.isEmpty else {
            completion?()
            return
        }
        
        DispatchQueue.logger.async {
            destinations.forEach {
                $0.write(level, with: message, path: path, function: function, line: line, error: error, context: context)
            }
            
            completion?()
        }
    }
}

public extension LogRepository {
    
    /// Log something generally unimportant (lowest priority; not written to file).
    ///
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func verbose(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: CustomStringConvertible]? = nil, completion: (() -> Void)? = nil) {
        write(.verbose, with: message, path: path, function: function, line: line, error: nil, context: context, completion: completion)
    }
}

public extension LogRepository {
    
    /// Log something which help during debugging (low priority; not written to file).
    ///
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func debug(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: CustomStringConvertible]? = nil, completion: (() -> Void)? = nil) {
        write(.debug, with: message, path: path, function: function, line: line, error: nil, context: context, completion: completion)
    }
}

public extension LogRepository {
    
    /// Log something which you are really interested but which is not an issue or error (normal priority).
    ///
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func info(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: CustomStringConvertible]? = nil, completion: (() -> Void)? = nil) {
        write(.info, with: message, path: path, function: function, line: line, error: nil, context: context, completion: completion)
    }
}

public extension LogRepository {
    
    /// Log something which may cause big trouble soon (high priority).
    ///
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func warning(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: CustomStringConvertible]? = nil, completion: (() -> Void)? = nil) {
        write(.warning, with: message, path: path, function: function, line: line, error: nil, context: context, completion: completion)
    }
}

public extension LogRepository {
    
    /// Log something which will keep you awake at night (highest priority).
    ///
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - error: Error of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func error(_ message: String, path: String = #file, function: String = #function, line: Int = #line, error: Error? = nil, context: [String: CustomStringConvertible]? = nil, completion: (() -> Void)? = nil) {
        write(.error, with: message, path: path, function: function, line: line, error: error, context: context, completion: completion)
    }
}
