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
    ///   - file: File of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - error: Error of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func write(
        _ level: LogAPI.Level,
        with message: String,
        file: String,
        function: String,
        line: Int,
        error: Error?,
        context: [String: CustomStringConvertible],
        completion: (() -> Void)?
    ) {
        let destinations = services.filter { $0.canWrite(for: level) }
        
        // Skip if does not meet minimum log level
        guard !destinations.isEmpty else {
            guard let completion = completion else { return }
            DispatchQueue.main.async { completion() }
            return
        }
        
        DispatchQueue.logger.async {
            let context = Self.context.merging(context) { $1 }
            
            destinations.forEach {
                $0.write(
                    level,
                    with: message,
                    file: file,
                    function: function,
                    line: line,
                    error: error,
                    context: context
                )
            }
            
            guard let completion = completion else { return }
            DispatchQueue.main.async { completion() }
        }
    }
}

public extension LogRepository {
    
    /// Log something generally unimportant (lowest priority; not written to file).
    ///
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - file: File of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func verbose(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: [String: CustomStringConvertible] = [:],
        completion: (() -> Void)? = nil
    ) {
        write(
            .verbose,
            with: message,
            file: file,
            function: function,
            line: line,
            error: nil,
            context: context,
            completion: completion
        )
    }
}

public extension LogRepository {
    
    /// Log something which help during debugging (low priority; not written to file).
    ///
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - file: File of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: [String: CustomStringConvertible] = [:],
        completion: (() -> Void)? = nil
    ) {
        write(
            .debug,
            with: message,
            file: file,
            function: function,
            line: line,
            error: nil,
            context: context,
            completion: completion
        )
    }
}

public extension LogRepository {
    
    /// Log something which you are really interested but which is not an issue or error (normal priority).
    ///
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - file: File of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: [String: CustomStringConvertible] = [:],
        completion: (() -> Void)? = nil
    ) {
        write(
            .info,
            with: message,
            file: file,
            function: function,
            line: line,
            error: nil,
            context: context,
            completion: completion
        )
    }
}

public extension LogRepository {
    
    /// Log something which may cause big trouble soon (high priority).
    ///
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - file: File of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func warning(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: [String: CustomStringConvertible] = [:],
        completion: (() -> Void)? = nil
    ) {
        write(
            .warning,
            with: message,
            file: file,
            function: function,
            line: line,
            error: nil,
            context: context,
            completion: completion
        )
    }
}

public extension LogRepository {
    
    /// Log something which will keep you awake at night (highest priority).
    ///
    /// - Parameters:
    ///   - level: The current level of the log entry.
    ///   - message: Description of the log.
    ///   - file: File of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    ///   - error: Error of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func error(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        error: Error? = nil,
        context: [String: CustomStringConvertible] = [:],
        completion: (() -> Void)? = nil
    ) {
        write(
            .error,
            with: message,
            file: file,
            function: function,
            line: line,
            error: error,
            context: context,
            completion: completion
        )
    }
}

public extension LogRepository {
    private static var context: [String: CustomStringConvertible] = [:]
    
    /// Adds a custom attribute to all future logs sent by this logger.
    func set(_ value: CustomStringConvertible?, forKey key: String) {
        DispatchQueue.logger.async {
            Self.context[key] = value
        }
    }
    
    /// Adds custom attributes to all future logs sent by this logger.
    func set(_ context: [String: CustomStringConvertible]) {
        DispatchQueue.logger.async {
            Self.context.merge(context) { $1 }
        }
    }
    
    /// Removes all the custom attribute from all future logs sent by this logger.
    func reset() {
        DispatchQueue.logger.async {
            Self.context.removeAll()
        }
    }
}

#if os(iOS)
import UIKit.UIApplication

public extension LogRepository {
    
    /// Sets the application properties to the logger so it can be used outside the main thread.
    func configure(with application: UIApplication) {
        let applicationState = application.applicationState.rawString
        let isProtectedDataAvailable = application.isProtectedDataAvailable
        
        set([
            "app_state": applicationState,
            "protected_data_available": isProtectedDataAvailable
        ])
    }
}

private extension UIApplication.State {
    
    /// The corresponding string of the raw type.
    var rawString: String {
        switch self {
        case .active:
            return "active"
        case .background:
            return "background"
        case .inactive:
            return "inactive"
        @unknown default:
            return "unknown"
        }
    }
}
#endif
