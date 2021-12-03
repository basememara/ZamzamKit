//
//  LogManager.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-06-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import SwiftUI

public class LogManager {
    private let services: [LogService]
    private var context: [String: CustomStringConvertible] = [:]

    public init(services: [LogService]) {
        self.services = services
    }
}

public extension LogManager {
    /// Adds a custom attribute to all future logs sent by this logger.
    func set(_ value: CustomStringConvertible?, forKey key: String) {
        DispatchQueue.logger.sync { context[key] = value }
    }

    /// Adds custom attributes to all future logs sent by this logger.
    func set(_ context: [String: CustomStringConvertible]) {
        DispatchQueue.logger.sync { self.context.merge(context) { $1 } }
    }

    /// Sets the application properties to the logger so it can be used outside the main thread.
    func set(context newPhase: ScenePhase) {
        set(newPhase.rawString, forKey: "app_state")
    }

    /// Removes all the custom attribute from all future logs sent by this logger.
    func reset() {
        DispatchQueue.logger.sync { context.removeAll() }
    }
}

public extension LogManager {
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
        defer {
            if let completion = completion {
                DispatchQueue.main.async { completion() }
            }
        }

        let destinations = services.filter { $0.canWrite(for: level) }
        guard !destinations.isEmpty else { return }

        DispatchQueue.logger.sync {
            let context = self.context.merging(context) { $1 }
            
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
        }
    }
}

public extension LogManager {
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
        file: String = #fileID,
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

public extension LogManager {
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
        file: String = #fileID,
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

public extension LogManager {
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
        file: String = #fileID,
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

public extension LogManager {
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
        file: String = #fileID,
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

public extension LogManager {
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
        file: String = #fileID,
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

private extension ScenePhase {
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
