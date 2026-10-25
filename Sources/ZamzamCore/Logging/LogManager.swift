//
//  LogManager.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-06-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import os

public final class LogManager: Sendable {
    private let services: [LogService]

    /// Attributes added to every entry. Writes hold the same lock, so destinations receive one entry at a time.
    private let context = OSAllocatedUnfairLock<[String: any CustomStringConvertible & Sendable]>(initialState: [:])

    public init(services: [LogService]) {
        self.services = services
    }
}

public extension LogManager {
    /// Adds a custom attribute to all future logs sent by this logger.
    func set(_ value: (any CustomStringConvertible & Sendable)?, forKey key: String) {
        context.withLock { $0[key] = value }
    }

    /// Adds custom attributes to all future logs sent by this logger.
    func set(_ context: [String: any CustomStringConvertible & Sendable]) {
        self.context.withLock { $0.merge(context) { $1 } }
    }

    /// Removes all the custom attribute from all future logs sent by this logger.
    func reset() {
        context.withLock { $0.removeAll() }
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
        context: [String: any CustomStringConvertible & Sendable],
        completion: (@Sendable () -> Void)?
    ) {
        defer {
            if let completion {
                DispatchQueue.main.async { completion() }
            }
        }

        let destinations = services.filter { $0.canWrite(for: level) }
        guard !destinations.isEmpty else { return }

        self.context.withLock { sessionContext in
            destinations.forEach {
                $0.write(
                    level,
                    with: message,
                    file: file,
                    function: function,
                    line: line,
                    error: error,
                    context: context,
                    sessionContext: sessionContext
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
        context: [String: any CustomStringConvertible & Sendable] = [:],
        completion: (@Sendable () -> Void)? = nil
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
        context: [String: any CustomStringConvertible & Sendable] = [:],
        completion: (@Sendable () -> Void)? = nil
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
        context: [String: any CustomStringConvertible & Sendable] = [:],
        completion: (@Sendable () -> Void)? = nil
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
    ///   - error: Error of the caller.
    ///   - context: Additional meta data.
    ///   - completion: The block to call when log entries sent.
    func warning(
        _ message: String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line,
        error: Error? = nil,
        context: [String: any CustomStringConvertible & Sendable] = [:],
        completion: (@Sendable () -> Void)? = nil
    ) {
        write(
            .warning,
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
        context: [String: any CustomStringConvertible & Sendable] = [:],
        completion: (@Sendable () -> Void)? = nil
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
