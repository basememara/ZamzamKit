//
//  LogHTTPService.swift
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
final public class LogHTTPService {
    private let urlRequest: URLRequest
    private let bulkEncode: ([String]) -> Data?
    private let maxEntriesInBuffer: Int
    private let minFlushLevel: LogAPI.Level
    private let isDebug: Bool
    private let constants: AppContext
    private let networkRepository: NetworkRepository
    
    private let deviceName = UIDevice.current.name
    private let deviceModel = UIDevice.current.model
    private var deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? ""
    private let osVersion = UIDevice.current.systemVersion
    
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
    ///   - constants: Provides details of the current context.
    ///   - networkRepository: The object used to send the HTTP request.
    ///   - notificationCenter: A notification dispatch mechanism that registers observers for flushing the buffer at certain app lifecycle events.
    public init(
        urlRequest: URLRequest,
        bulkEncode: @escaping ([String]) -> Data?,
        maxEntriesInBuffer: Int,
        minFlushLevel: LogAPI.Level = .none,
        isDebug: Bool,
        constants: AppContext,
        networkRepository: NetworkRepository,
        notificationCenter: NotificationCenter
    ) {
        self.urlRequest = urlRequest
        self.bulkEncode = bulkEncode
        self.maxEntriesInBuffer = maxEntriesInBuffer
        self.minFlushLevel = minFlushLevel
        self.isDebug = isDebug
        self.constants = constants
        self.networkRepository = networkRepository
        
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

public extension LogHTTPService {
    
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
                "name": constants.appDisplayName ?? "Unknown",
                "version": constants.appVersion ?? "Unknown",
                "build": constants.appBuild ?? "Unknown",
                "bundle_id": constants.appBundleID ?? "Unknown",
                "is_extension": constants.isAppExtension,
                "is_debug": isDebug,
                "distribution": constants.isRunningInAppStore ? "appstore"
                    : constants.isInTestFlight ? "testflight"
                    : constants.isAdHocDistributed ? "adhoc"
                    : constants.isRunningOnSimulator ? "simulator"
                    : "unknown"
            ],
            "device": [
                "device_id": deviceIdentifier,
                "device_name": !constants.isRunningInAppStore ? deviceName : "",
                "device_model": deviceModel,
                "os_version": osVersion,
                "is_simulator": constants.isRunningOnSimulator
            ],
            "code": [
                "file": file,
                "function": function,
                "line": line
            ]
        ]
        
        if !context.isEmpty {
            payload["context"] = context
        }
        
        payload.merge(parameters) { $1 }
        
        guard let log = payload.jsonString() else {
            print("🤍 \(timestamp: Date()) [PCO] ERROR Logger unable to encode parameters for destination.")
            return
        }
        
        // Store in buffer for sending later
        buffer.append((level, log))
        
        // Flush buffer threshold reached
        guard buffer.count > maxEntriesInBuffer else { return }
        send()
    }
}

private extension LogHTTPService {
    
    func send() {
        guard !buffer.isEmpty, minFlushLevel == .none || buffer.contains(where: { $0.0 >= minFlushLevel }) else { return }
        
        let logs = buffer
        buffer = []
        
        guard let data = bulkEncode(logs.map { $0.1 }) else {
            print("🤍 \(timestamp: Date()) [PCO] PRINT Could not begin log destination task")
            return
        }
        
        var request = urlRequest
        request.httpBody = data
        
        BackgroundTask.run(for: .shared) { task in
            self.networkRepository.send(with: request) {
                // Add back to the buffer if could not send
                if case .failure(let error) = $0 {
                    print("🤍 \(timestamp: Date()) [PCO] PRINT Error from log destination: \(error)")
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
