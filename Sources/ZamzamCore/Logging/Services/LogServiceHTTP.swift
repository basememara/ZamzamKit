//
//  LogServiceHTTP.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-04.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import Foundation.NSDate
import Foundation.NSData
import Foundation.NSJSONSerialization
import Foundation.NSNotification
import Foundation.NSURLRequest
#if os(iOS)
import UIKit.UIApplication
import UIKit.UIDevice
#endif

/// Log destination for sending over HTTP.
final public class LogServiceHTTP {
    private let urlRequest: URLRequest
    private let maxEntriesInBuffer: Int
    private let minFlushLevel: LogAPI.Level
    private let isDebug: Bool
    private let distribution: Distribution
    private let networkManager: NetworkManager

    /// Closure that converts the buffer to data.
    private let bufferEncode: ([Entry]) -> Data?

    /// Stores the log entries in memory until it is ready to send.
    private var buffer = Atomic<[Entry]>([])

    private var cancellable = Set<AnyCancellable>()

    /// The initializer of the log destination.
    ///
    /// - Parameters:
    ///   - urlRequest: A URL load request for the destination. Leave data `nil` as this will be added to the `httpBody` upon sending.
    ///   - bulkEncode: The handler to combine multiple log entries together.
    ///   - maxEntriesInBuffer: The threshold of the buffer before sending to the destination.
    ///   - minFlushLevel: The threshold of the log level before sending to the destination.
    ///   - isDebug: Determines if the current app is running in debug mode.
    ///   - distribution: Provides details of the current distribution.
    ///   - networkManager: The object used to send the HTTP request.
    ///   - notificationCenter: A notification dispatch mechanism that registers observers for flushing the buffer at certain app lifecycle events.
    public init(
        urlRequest: URLRequest,
        bufferEncode: @escaping ([Entry]) -> Data?,
        maxEntriesInBuffer: Int,
        minFlushLevel: LogAPI.Level = .none,
        isDebug: Bool,
        distribution: Distribution,
        networkManager: NetworkManager,
        notificationCenter: NotificationCenter
    ) {
        self.urlRequest = urlRequest
        self.bufferEncode = bufferEncode
        self.maxEntriesInBuffer = maxEntriesInBuffer
        self.minFlushLevel = minFlushLevel
        self.isDebug = isDebug
        self.distribution = distribution
        self.networkManager = networkManager

        #if os(iOS)
        notificationCenter.publisher(for: UIApplication.willResignActiveNotification, object: nil)
            .merge(with: notificationCenter.publisher(for: UIApplication.willTerminateNotification, object: nil))
            .sink { [weak self] _ in self?.send() }
            .store(in: &cancellable)
        #endif
    }
}

public extension LogServiceHTTP {
    /// A log entry that contains details of the event.
    struct Entry {
        public let level: LogAPI.Level
        public let date: Date
        public let platform: String
        public let payload: String
    }
}

public extension LogServiceHTTP {
    /// Appends the log to the buffer that will be queued for later sending.
    ///
    /// The buffer size is determined in the initializer. Once the threshold is met,
    /// the entries will be flushed and sent to the destination. The buffer is
    /// also automatically flushed on the `willResignActive` and
    /// `willTerminate` events.
    ///
    /// - Parameters:
    ///   - parameters: The values that will be merged and sent to the destination.
    ///   - level: The current level of the log entry.
    ///   - file: File of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    func write(
        _ parameters: [String: Any],
        level: LogAPI.Level,
        date: Date,
        file: String,
        function: String,
        line: Int,
        context: [String: CustomStringConvertible]
    ) {
        var device: [String: Any] = [
            "is_simulator": distribution.isRunningOnSimulator
        ]

        #if os(iOS) || os(watchOS)
        device.merge([
            "device_id": distribution.deviceIdentifier,
            "device_name": isDebug ? distribution.deviceName : "***",
            "device_model": distribution.deviceModel,
            "platform": distribution.platform,
            "os_version": distribution.osVersion
        ]) { $1 }
        #endif

        var payload: [String: Any] = [
            "app": [
                "name": distribution.appDisplayName ?? "Unknown",
                "version": distribution.appVersion ?? "Unknown",
                "build": distribution.appBuild ?? "Unknown",
                "bundle_id": distribution.appBundleID ?? "Unknown",
                "is_extension": distribution.isAppExtension,
                "is_debug": isDebug,
                "distribution": distribution.isRunningInAppStore ? "appstore"
                    : distribution.isInTestFlight ? "testflight"
                    : distribution.isAdHocDistributed ? "adhoc"
                    : distribution.isRunningOnSimulator ? "simulator"
                    : "unknown"
            ],
            "device": device,
            "code": [
                "file": "\(file)",
                "function": function,
                "line": line
            ]
        ]

        if !context.isEmpty {
            payload["context"] = context
        }

        payload.merge(parameters) { $1 }

        guard let log = payload.jsonString() ?? {
            payload["context"] = "ERROR Logger unable to encode context for destination"
            return payload.jsonString()
        }() else {
            print("🤍 \(Date.now.formatted(date: .omitted, time: .standard)) ERROR Logger unable to encode parameters for destination.")
            return
        }

        // Store in buffer for sending later
        buffer.value { $0.append(Entry(level: level, date: date, platform: distribution.platform, payload: log)) }

        // Flush buffer threshold reached or in background
        guard buffer.value.count > maxEntriesInBuffer
                || context["app_state"]?.description == "background"
        else {
            return
        }

        send()
    }
}

private extension LogServiceHTTP {
    func send() {
        guard !buffer.value.isEmpty,
              minFlushLevel == .none || buffer.value.contains(where: { $0.level >= minFlushLevel })
        else {
            return
        }

        let entries = buffer.value
        buffer.value { $0 = [] }

        guard let data = bufferEncode(entries) else {
            print("🤍 \(Date.now.formatted(date: .omitted, time: .standard)) PRINT Could not begin log destination task")
            return
        }

        Task {
            do {
                var request = urlRequest
                request.httpBody = data
                try await networkManager.send(request)
            } catch {
                // Add back to the buffer if could not send
                print("🤍 \(Date.now.formatted(date: .omitted, time: .standard)) PRINT Error from log destination: \(error)")
                buffer.value { $0 += entries }
            }
        }
    }
}
