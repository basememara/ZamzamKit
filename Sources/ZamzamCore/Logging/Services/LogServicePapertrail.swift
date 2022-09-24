//
//  LogServicePapertrail.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-03-31.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation

/// Sends a message to Papertrail error logs.
public struct LogServicePapertrail: LogService {
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
                url: URL(safeString: "https://logs.collector.solarwinds.com/v1/logs"),
                method: .post,
                data: nil,
                headers: ["Authorization": "Basic \(apiKey.base64Encoded())"]
            ),
            bufferEncode: Self.bufferEncode,
            maxEntriesInBuffer: maxLogEntriesInBuffer,
            minFlushLevel: minFlushLevel,
            isDebug: isDebug,
            distribution: distribution,
            networkManager: networkManager,
            notificationCenter: notificationCenter
        )
    }
}

public extension LogServicePapertrail {
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
            "timestamp": DateFormatter.zuluFormatter.string(from: .now),
            "level": {
                switch level {
                case .debug, .verbose, .none:
                    return "DEBUG"
                case .info:
                    return "INFO"
                case .warning:
                    return "WARN"
                case .error:
                    return "ERROR"
                }
            }(),
            "message": message,
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

private extension LogServicePapertrail {
    static func bufferEncode(entries: [LogServiceHTTP.Entry]) -> Data? {
        let levelNumber = { (level: LogAPI.Level) -> Int in
            switch level {
            case .debug, .verbose, .none:
                return 6
            case .info:
                return 5
            case .warning:
                return 4
            case .error:
                return 3
            }
        }

        return entries
            .map { entry in
                [
                    "<\(levelNumber(entry.level))>",
                    "\(DateFormatter.zuluFormatter.string(from: entry.date))",
                    "\(entry.platform.lowercased()) \(Bundle.main.bundleIdentifier ?? "") \(entry.payload)"
                ].joined(separator: " ")
            }
            .joined(separator: "\n")
            .data(using: .utf8)
    }
}
