//
//  LogAPI.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-06-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSURL

public protocol LogService {
    
    /// The minimum level required to create log entries.
    var minLevel: LogAPI.Level { get }
    
    /// Log an entry to the destination.
    ///
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - file: File of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - error: Error of the caller.
    ///   - context: Additional meta data.
    func write(
        _ level: LogAPI.Level,
        with message: String,
        file: String,
        function: String,
        line: Int,
        error: Error?,
        context: [String: CustomStringConvertible]
    )
    
    /// Returns if the logger should process the entry for the specified log level.
    func canWrite(for level: LogAPI.Level) -> Bool
    
    /// The output of the message and supporting information.
    ///
    /// - Parameters:
    ///   - message: Description of the log.
    ///   - file: File of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - error: Error of the caller.
    ///   - context: Additional meta data.
    func format(
        _ message: String,
        _ file: String,
        _ function: String,
        _ line: Int,
        _ error: Error?,
        _ context: [String: CustomStringConvertible]
    ) -> String
}

public extension LogService {
    
    /// Determines if the service has the minimum level to log.
    func canWrite(for level: LogAPI.Level) -> Bool {
        minLevel <= level && level != .none
    }
    
    /// The string output of the log.
    func format(
        _ message: String,
        _ file: String,
        _ function: String,
        _ line: Int,
        _ error: Error?,
        _ context: [String: CustomStringConvertible]
    ) -> String {
        var output = "\(URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent).\(function):\(line) - \(message)"
        
        if let error = error {
            output += " | Error: \(error)"
        }
        
        if !context.isEmpty {
            output += " | Context: \(context)"
        }
        
        return output
    }
}

// MARK: - Namespace

public enum LogAPI {
    
    public enum Level: Comparable, CaseIterable {
        case verbose
        case debug
        case info
        case warning
        case error
        
        /// Disables a log service when used as minimum level
        case none
    }
}
