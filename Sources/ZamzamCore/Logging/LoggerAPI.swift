//
//  Loggable.swift
//  PrayCore
//
//  Created by Basem Emara on 2019-06-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation

public protocol LoggerStore: AppInfo {
    
    /**
     Log something generally unimportant (lowest priority; not written to file)
     
     - parameter message: Description of the log.
     - parameter includeMeta: If true, will append the meta data to the log.
     - parameter path: Path of the caller.
     - parameter function: Function of the caller.
     - parameter line: Line of the caller.
     */
    func verbose(_ message: String, path: String, function: String, line: Int, context: [String: Any]?)
    
    /**
     Log something which help during debugging (low priority; not written to file)
     
     - parameter message: Description of the log.
     - parameter includeMeta: If true, will append the meta data to the log.
     - parameter path: Path of the caller.
     - parameter function: Function of the caller.
     - parameter line: Line of the caller.
     */
    func debug(_ message: String, path: String, function: String, line: Int, context: [String: Any]?)
    
    /**
     Log something which you are really interested but which is not an issue or error (normal priority)
     
     - parameter message: Description of the log.
     - parameter includeMeta: If true, will append the meta data to the log.
     - parameter path: Path of the caller.
     - parameter function: Function of the caller.
     - parameter line: Line of the caller.
     */
    func info(_ message: String, path: String, function: String, line: Int, context: [String: Any]?)
    
    /**
     Log something which may cause big trouble soon (high priority)
     
     - parameter message: Description of the log.
     - parameter includeMeta: If true, will append the meta data to the log.
     - parameter path: Path of the caller.
     - parameter function: Function of the caller.
     - parameter line: Line of the caller.
     */
    func warn(_ message: String, path: String, function: String, line: Int, context: [String: Any]?)
    
    /**
     Log something which will keep you awake at night (highest priority)
     
     - parameter message: Description of the log.
     - parameter includeMeta: If true, will append the meta data to the log.
     - parameter path: Path of the caller.
     - parameter function: Function of the caller.
     - parameter line: Line of the caller.
     */
    func error(_ message: String, path: String, function: String, line: Int, context: [String: Any]?)
}

public protocol LoggerWorkerType: LoggerStore {}
public extension LoggerWorkerType {
    
    /// Log something generally unimportant (lowest priority; not written to file)
    func verbose(_ message: String, path: String = #file, function: String = #function, line: Int = #line) {
        verbose(message, path: path, function: function, line: line, context: nil)
    }
    
    /// Log something which help during debugging (low priority; not written to file)
    func debug(_ message: String, path: String = #file, function: String = #function, line: Int = #line) {
        debug(message, path: path, function: function, line: line, context: nil)
    }
    
    /// Log something which you are really interested but which is not an issue or error (normal priority)
    func info(_ message: String, path: String = #file, function: String = #function, line: Int = #line) {
        info(message, path: path, function: function, line: line, context: nil)
    }
    
    /// Log something which may cause big trouble soon (high priority)
    func warn(_ message: String, path: String = #file, function: String = #function, line: Int = #line) {
        warn(message, path: path, function: function, line: line, context: nil)
    }
    
    /// Log something which will keep you awake at night (highest priority)
    func error(_ message: String, path: String = #file, function: String = #function, line: Int = #line) {
        error(message, path: path, function: function, line: line, context: nil)
    }
}
