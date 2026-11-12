//
//  LogAPI.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-06-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSURL

/// A destination for log entries, such as the console, the system log or a file.
public protocol LogService: Sendable {
    /// The minimum level required to create log entries.
    var minLevel: LogAPI.Level { get }

    /// Writes an entry to the destination. `LogManager` calls it only for a level that `canWrite(for:)` accepts.
    ///
    /// - Parameters:
    ///   - context: Attributes for this entry alone.
    ///   - sessionContext: The attributes set on the logger, for the destination to include or leave out.
    func write(
        _ level: LogAPI.Level,
        with message: String,
        file: String,
        function: String,
        line: Int,
        error: Error?,
        context: [String: any CustomStringConvertible & Sendable],
        sessionContext: [String: any CustomStringConvertible & Sendable]
    )

    /// Returns if the logger should process the entry for the specified log level.
    func canWrite(for level: LogAPI.Level) -> Bool

    /// Returns the text the destination writes for an entry.
    func format(
        _ message: String,
        _ file: String,
        _ function: String,
        _ line: Int,
        _ error: Error?,
        _ context: [String: any CustomStringConvertible & Sendable]
    ) -> String
}

public extension LogService {
    /// Returns whether the level is at or above `minLevel`. The `none` level is never written.
    func canWrite(for level: LogAPI.Level) -> Bool {
        minLevel <= level && level != .none
    }

    /// Returns `File.function:line - message`, followed by the error and the context when there are any.
    func format(
        _ message: String,
        _ file: String,
        _ function: String,
        _ line: Int,
        _ error: Error?,
        _ context: [String: any CustomStringConvertible & Sendable]
    ) -> String {
        var output = "\(URL(fileURLWithPath: file, isDirectory: false).deletingPathExtension().lastPathComponent).\(function):\(line) - \(message)"

        if let error {
            output += " | Error: \(error)"
        }

        if !context.isEmpty {
            output += " | Context: \(context)"
        }

        return output
    }
}

extension LogAPI.Level {
    func prefix(time: String, subsystem: String) -> String? {
        switch self {
        case .verbose:
            "💜 \(time) VERBOSE [\(subsystem)]"
        case .debug:
            "💚 \(time) DEBUG [\(subsystem)]"
        case .info:
            "💙 \(time) INFO [\(subsystem)]"
        case .warning:
            "💛 \(time) WARNING [\(subsystem)]"
        case .error:
            "❤️ \(time) ERROR [\(subsystem)]"
        case .none:
            nil
        }
    }
}

// MARK: - Namespace

/// The namespace for the logging types.
public enum LogAPI {
    /// How important an entry is, from `verbose` up to `error`.
    public enum Level: Comparable, CaseIterable, Sendable {
        /// Detail that is rarely needed.
        case verbose
        /// Detail that helps while debugging.
        case debug
        /// Something worth knowing that isn't a problem.
        case info
        /// Something that may cause trouble soon.
        case warning
        /// A failure.
        case error

        /// Disables a log service when used as minimum level
        case none // swiftlint:disable:this discouraged_none_name
    }
}
