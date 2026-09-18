//
//  LoggingTests.swift
//  ZamzamCore
//  
//
//  Created by Basem Emara on 2019-11-10.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct LoggingTests {}

extension LoggingTests {
    @Test(.timeLimit(.minutes(1)))
    func entriesAreWritten() async {
        // Given
        let logService = LogTestService(minLevel: .verbose)
        let log = LogManager(services: [logService])
        let group = DispatchGroup()

        // When
        LogAPI.Level.allCases.forEach {
            group.enter()

            log.write($0, with: "\($0) test", file: #fileID, function: #function, line: #line, error: nil, context: [:]) {
                group.leave()
            }
        }

        await withCheckedContinuation { continuation in
            group.notify(queue: .global()) { continuation.resume() }
        }

        // Then
        #expect(logService.entries[.verbose] == ["\(LogAPI.Level.verbose) test"])
        #expect(logService.entries[.debug] == ["\(LogAPI.Level.debug) test"])
        #expect(logService.entries[.info] == ["\(LogAPI.Level.info) test"])
        #expect(logService.entries[.warning] == ["\(LogAPI.Level.warning) test"])
        #expect(logService.entries[.error] == ["\(LogAPI.Level.error) test"])
        #expect(logService.entries[.none] == [])
    }
}

extension LoggingTests {
    // swiftlint:disable:next function_body_length
    @Test
    func minLevelsObeyed() {
        // Given
        let verboseService = LogTestService(minLevel: .verbose)
        let debugService = LogTestService(minLevel: .debug)
        let infoService = LogTestService(minLevel: .info)
        let warningService = LogTestService(minLevel: .warning)
        let errorService = LogTestService(minLevel: .error)
        let noneService = LogTestService(minLevel: .none)

        // Then
        #expect(verboseService.canWrite(for: .verbose))
        #expect(verboseService.canWrite(for: .debug))
        #expect(verboseService.canWrite(for: .info))
        #expect(verboseService.canWrite(for: .warning))
        #expect(verboseService.canWrite(for: .error))
        #expect(!(verboseService.canWrite(for: .none)))

        #expect(!(debugService.canWrite(for: .verbose)))
        #expect(debugService.canWrite(for: .debug))
        #expect(debugService.canWrite(for: .info))
        #expect(debugService.canWrite(for: .warning))
        #expect(debugService.canWrite(for: .error))
        #expect(!(debugService.canWrite(for: .none)))

        #expect(!(infoService.canWrite(for: .verbose)))
        #expect(!(infoService.canWrite(for: .debug)))
        #expect(infoService.canWrite(for: .info))
        #expect(infoService.canWrite(for: .warning))
        #expect(infoService.canWrite(for: .error))
        #expect(!(infoService.canWrite(for: .none)))

        #expect(!(warningService.canWrite(for: .verbose)))
        #expect(!(warningService.canWrite(for: .debug)))
        #expect(!(warningService.canWrite(for: .info)))
        #expect(warningService.canWrite(for: .warning))
        #expect(warningService.canWrite(for: .error))
        #expect(!(warningService.canWrite(for: .none)))

        #expect(!(errorService.canWrite(for: .verbose)))
        #expect(!(errorService.canWrite(for: .debug)))
        #expect(!(errorService.canWrite(for: .info)))
        #expect(!(errorService.canWrite(for: .warning)))
        #expect(errorService.canWrite(for: .error))
        #expect(!(errorService.canWrite(for: .none)))

        #expect(!(noneService.canWrite(for: .verbose)))
        #expect(!(noneService.canWrite(for: .debug)))
        #expect(!(noneService.canWrite(for: .info)))
        #expect(!(noneService.canWrite(for: .warning)))
        #expect(!(noneService.canWrite(for: .error)))
        #expect(!(noneService.canWrite(for: .none)))
    }
}

extension LoggingTests {
    // Serialized: saturates the CPU, which skews anything running beside it.
    @Test(.timeLimit(.minutes(1)))
    func threadSafety() async {
        // Given
        let logService = LogTestService(minLevel: .verbose)
        let log = LogManager(services: [logService])
        let group = DispatchGroup()
        let iterations = 1_000 // 10_000

        // When
        DispatchQueue.concurrentPerform(iterations: iterations) { iteration in
            LogAPI.Level.allCases.forEach {
                group.enter()

                log.write($0, with: "\($0) test \(iteration)", file: #fileID, function: #function, line: #line, error: nil, context: [:]) {
                    group.leave()
                }
            }
        }

        await withCheckedContinuation { continuation in
            group.notify(queue: .global()) { continuation.resume() }
        }

        // Then
        #expect(logService.entries[.verbose]?.count == iterations)
        #expect(logService.entries[.debug]?.count == iterations)
        #expect(logService.entries[.info]?.count == iterations)
        #expect(logService.entries[.warning]?.count == iterations)
        #expect(logService.entries[.error]?.count == iterations)
        #expect(logService.entries[.none]?.isEmpty == true)
    }
}

// MARK: - Mocks

private extension LoggingTests {
    /// Writes are serialized by `LogManager`'s logger queue, hence the unchecked conformance.
    final class LogTestService: LogService, @unchecked Sendable {
        let minLevel: LogAPI.Level

        init(minLevel: LogAPI.Level) {
            self.minLevel = minLevel
        }

        // Spy
        var entries = Dictionary(
            uniqueKeysWithValues: LogAPI.Level.allCases.map { ($0, [String]()) }
        )

        func write(
            _ level: LogAPI.Level,
            with message: String,
            file: String,
            function: String,
            line: Int,
            error: Error?,
            context: [String: any CustomStringConvertible & Sendable],
            sessionContext: [String: any CustomStringConvertible & Sendable]
        ) {
            entries.updateValue(entries[level, default: []] + [message], forKey: level)
        }
    }
}
