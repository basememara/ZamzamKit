//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-11-01.
//

import Foundation
import os

/// Sends a message to the logging system, optionally specifying a custom log object, log level, and any message format arguments.
public struct LogOSStore: LogStore {
    private let minLevel: LogAPI.Level
    private let subsystem: String
    private let category: String
    private let log: OSLog
    
    private let queue = DispatchQueue(label: "io.zamzam.LogOSStore", qos: .utility)
    
    public init(minLevel: LogAPI.Level, subsystem: String, category: String) {
        self.minLevel = minLevel
        self.subsystem = subsystem
        self.category = category
        self.log = OSLog(subsystem: subsystem, category: category)
    }
}

public extension LogOSStore {
    
    func verbose(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard minLevel <= .verbose else { return }
        queue.async { os_log("%@", log: self.log, type: .debug, message) }
    }
    
    func debug(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard minLevel <= .debug else { return }
        queue.async { os_log("%@", log: self.log, type: .debug, message) }
    }
    
    func info(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard minLevel <= .info else { return }
        queue.async { os_log("%@", log: self.log, type: .info, message) }
    }
    
    func warning(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard minLevel <= .warning else { return }
        queue.async { os_log("%@", log: self.log, type: .default, message) }
    }
    
    func error(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard minLevel <= .error else { return }
        queue.async { os_log("%@", log: self.log, type: .error, message) }
    }
}
