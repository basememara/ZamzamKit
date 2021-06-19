//
//  LogServiceDataDog.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-04-21.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation

/// Sends a message to DataDog error logs.
public struct LogServiceDataDog: LogService {
    public var minLevel: LogAPI.Level { minLevelSetting() }
    private let minLevelSetting: () -> LogAPI.Level
    private let distribution: Distribution
    private let environment: String
    private let service: LogServiceHTTP

    public init(
        apiKey: String,
        minLevel: @autoclosure @escaping () -> LogAPI.Level, // Allows runtime changes
        minFlushLevel: LogAPI.Level,
        maxLogEntriesInBuffer: Int,
        isDebug: Bool,
        distribution: Distribution,
        networkManager: NetworkManager,
        environment: String,
        notificationCenter: NotificationCenter
    ) {
        self.minLevelSetting = minLevel
        self.distribution = distribution
        self.environment = environment

        self.service = LogServiceHTTP(
            urlRequest: URLRequest(
                url: URL(safeString: "https://http-intake.logs.datadoghq.com/v1/input/?ddsource=ios&service=praywatch"),
                method: .post,
                data: nil,
                headers: ["DD-API-KEY": apiKey]
            ),
            bufferEncode: { "[\($0.map(\.payload).joined(separator: ","))]".data(using: .utf8) },
            maxEntriesInBuffer: maxLogEntriesInBuffer,
            minFlushLevel: minFlushLevel,
            isDebug: isDebug,
            distribution: distribution,
            networkManager: networkManager,
            notificationCenter: notificationCenter
        )
    }
}

public extension LogServiceDataDog {
    func write(
        _ level: LogAPI.Level,
        with message: String,
        file: String,
        function: String,
        line: Int,
        error: Error?,
        context: [String: CustomStringConvertible]
    ) {
        var parameters: [String: Any] = [
            "date": DateFormatter.zuluFormatter.string(from: .now),
            "status": {
                switch level {
                case .debug, .verbose, .none:
                    return "debug"
                case .info:
                    return "info"
                case .warning:
                    return "warn"
                case .error:
                    return "error"
                }
            }(),
            "message": message,
            "ddtags": "env:\(environment.lowercased()),version:\(distribution.appVersion ?? "unknown")",
            "user": [
                "language": Locale.preferredLanguages[0],
                "region": Locale.current.identifier
            ]
        ]

        if let error = error {
            parameters["error_description"] = String(describing: error)
        }

        service.write(parameters, level: level, date: .now, file: file, function: function, line: line, context: context)
    }
}
