//
//  LogHTTPService.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-04.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import Foundation.NSNotification
import Foundation.NSURLRequest
import UIKit.UIApplication
import UIKit.UIDevice

/// Log destination for sending over HTTP.
final public class LogHTTPService {
    private let urlRequest: URLRequest
    private let maxEntriesInBuffer: Int
    private let appInfo: AppInfo
    private let networkRepository: NetworkRepository
    
    private let deviceName = UIDevice.current.name
    private let deviceModel = UIDevice.current.model
    private var deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? ""
    private let osVersion = UIDevice.current.systemVersion
    
    /// Stores the log entries in memory until it is ready to send.
    private var buffer: [String] = []
    
    /// The initializer of the log destination.
    ///
    /// - Parameters:
    ///   - urlRequest: A URL load request for the destination. Leave data `nil` as this will be added to the `httpBody` upon sending.
    ///   - maxEntriesInBuffer: The threshold of the buffer before sending to the destination.
    ///   - appInfo: Provides details of the current app.
    ///   - networkRepository: The object used to send the HTTP request.
    ///   - notificationCenter: A notification dispatch mechanism that registers observers for flushing the buffer at certain app lifecycle events.
    public init(
        urlRequest: URLRequest,
        maxEntriesInBuffer: Int,
        appInfo: AppInfo,
        networkRepository: NetworkRepository,
        notificationCenter: NotificationCenter
    ) {
        self.urlRequest = urlRequest
        self.maxEntriesInBuffer = maxEntriesInBuffer
        self.appInfo = appInfo
        self.networkRepository = networkRepository
        
        notificationCenter.addObserver(
            self,
            selector: #selector(send),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(send),
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
    ///   - parameters: The values that will be merged and sent to the detination.
    ///   - level: The current level of the log entry.
    ///   - path: Path of the caller.
    ///   - function: Function of the caller.
    ///   - line: Line of the caller.
    func write(
        _ parameters: [String: Any],
        level: LogAPI.Level,
        path: String,
        function: String,
        line: Int
    ) {
        let session: [String: Any] = [
            "app": [
                "name": appInfo.appDisplayName ?? "Unknown",
                "version": appInfo.appVersion ?? "Unknown",
                "build": appInfo.appBuild ?? "Unknown",
                "bundle_id": appInfo.appBundleID ?? "Unknown"
            ],
            "device": [
                "device_id": deviceIdentifier,
                "device_name": deviceName,
                "device_model": deviceModel,
                "os_version": osVersion,
                "is_testflight": appInfo.isInTestFlight,
                "is_simulator": appInfo.isRunningOnSimulator
            ],
            "code": [
                "path": path,
                "function": function,
                "line": line
            ]
        ]
        
        let merged = parameters.merging(session) { (parameter, _) in parameter }
        
        guard let log = merged.jsonString() else {
            print("ERROR: Logger unable to serialize parameters for destination.")
            return
        }
        
        // Store in buffer for sending later
        buffer.append(log)
        
        // Flush buffer threshold reached
        guard buffer.count > maxEntriesInBuffer else { return }
        send()
    }
}

private extension LogHTTPService {
    
    @objc func send() {
        guard !buffer.isEmpty else { return }
        
        let logs = buffer
        buffer = []
        
        guard let data = logs.joined(separator: "\n").data(using: .utf8) else {
            debugPrint("Could not begin log destination task")
            return
        }
        
        var request = urlRequest
        request.httpBody = data
        
        BackgroundTask.run(for: .shared) { task in
            self.networkRepository.send(with: request) {
                // Add back to the buffer if could not send
                if case .failure(let error) = $0 {
                    debugPrint("Error from log destination: \(error)")
                    self.buffer += logs
                }
                
                task.end()
            }
        }
    }
}
#endif
