//
//  LogManager.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-06-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import os

/// Sends each log entry to every service whose minimum level allows it.
///
///     let log = LogManager(
///         services: [
///             LogServiceConsole(minLevel: .debug, subsystem: "MyApp"),
///             LogServiceOS(minLevel: .warning, subsystem: "com.example.MyApp", category: "Network", isDebug: false)
///         ]
///     )
///
///     log.info("Signed in", context: ["plan": "free"])
public final class LogManager: Sendable {
    private let services: [LogService]

    /// Attributes added to every entry. Writes hold the same lock, so destinations receive one entry at a time.
    private let context = OSAllocatedUnfairLock<[String: any CustomStringConvertible & Sendable]>(initialState: [:])

    /// Creates a logger that writes to the given services, in their order.
    public init(services: [LogService]) {
        self.services = services
    }
}

public extension LogManager {
    /// Sets an attribute passed to the services with every later entry. A `nil` value removes it.
    func set(_ value: (any CustomStringConvertible & Sendable)?, forKey key: String) {
        context.withLock { $0[key] = value }
    }

    /// Adds attributes passed to the services with every later entry, replacing those of the same key.
    func set(_ context: [String: any CustomStringConvertible & Sendable]) {
        self.context.withLock { $0.merge(context) { $1 } }
    }

    /// Removes every attribute set on the logger.
    func reset() {
        context.withLock { $0.removeAll() }
    }
}

public extension LogManager {
    /// Writes an entry to every service that accepts its level, one entry at a time.
    ///
    /// - Parameters:
    ///   - context: Attributes for this entry alone.
    ///   - completion: Called on the main queue after the services return, including when none takes the entry.
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
    /// Logs detail of the lowest priority, at the `verbose` level.
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
    /// Logs something that helps while debugging, at the `debug` level.
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
    /// Logs something worth knowing that isn't a problem, at the `info` level.
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
    /// Logs something that may cause trouble soon, at the `warning` level, with the error behind it.
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
    /// Logs a failure, at the `error` level, with the error behind it.
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
