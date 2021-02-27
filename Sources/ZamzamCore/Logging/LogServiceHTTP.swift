//
//  LogServiceHTTP.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-04.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import Foundation.NSData
import Foundation.NSJSONSerialization
import Foundation.NSNotification
import Foundation.NSURLRequest
import UIKit.UIApplication
import UIKit.UIDevice

/// Log destination for sending over HTTP.
final public class LogServiceHTTP {
    private let urlRequest: URLRequest
    private let maxEntriesInBuffer: Int
    private let minFlushLevel: LogAPI.Level
    private let isDebug: Bool
    private let distribution: Distribution
    private let networkManager: NetworkManager

    /// Closure that converts the buffer to data.
    private let bufferEncode: ([(LogAPI.Level, String)]) -> Data?

    /// Stores the log entries in memory until it is ready to send.
    private var buffer: [(LogAPI.Level, String)] = []

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
        bufferEncode: @escaping ([(LogAPI.Level, String)]) -> Data?,
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

        notificationCenter.addObserver(
            self,
            selector: #selector(applicationWillExit),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )

        notificationCenter.addObserver(
            self,
            selector: #selector(applicationWillExit),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
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
        file: String,
        function: String,
        line: Int,
        context: [String: CustomStringConvertible]
    ) {
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
            "device": [
                "device_id": distribution.deviceIdentifier,
                "device_name": !distribution.isRunningInAppStore ? distribution.deviceName : "***",
                "device_model": distribution.deviceModel,
                "os_version": distribution.osVersion,
                "is_simulator": distribution.isRunningOnSimulator
            ],
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

        guard let log = payload.jsonString() else {
            print("🤍 \(timestamp: Date()) ERROR Logger unable to encode parameters for destination.")
            return
        }

        // Store in buffer for sending later
        buffer.append((level, log))

        // Flush buffer threshold reached
        guard buffer.count > maxEntriesInBuffer else { return }
        send()
    }
}

private extension LogServiceHTTP {

    func send() {
        guard !buffer.isEmpty,
              minFlushLevel == .none || buffer.contains(where: { $0.0 >= minFlushLevel })
        else {
            return
        }

        let logs = buffer
        buffer = []

        guard let data = bufferEncode(logs) else {
            print("🤍 \(timestamp: Date()) PRINT Could not begin log destination task")
            return
        }

        var request = urlRequest
        request.httpBody = data

        BackgroundTask.run(for: .shared) { task in
            networkManager.send(request) {
                // Add back to the buffer if could not send
                if case let .failure(error) = $0 {
                    print("🤍 \(timestamp: Date()) PRINT Error from log destination: \(error)")
                    DispatchQueue.logger.async { self.buffer += logs }
                }

                task.end()
            }
        }
    }

    @objc func applicationWillExit() {
        DispatchQueue.logger.async {
            self.send()
        }
    }
}
#endif
