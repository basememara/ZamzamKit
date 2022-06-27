//
//  LoggingTests.swift
//  ZamzamCore
//  
//
//  Created by Basem Emara on 2019-11-10.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class LoggingTests: XCTestCase {}

extension LoggingTests {
    func testEntriesAreWritten() {
        // Given
        let promise = expectation(description: #function)
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

        group.notify(queue: .global()) {
            promise.fulfill()
        }

        wait(for: [promise], timeout: 10)

        // Then
        XCTAssertEqual(logService.entries[.verbose], ["\(LogAPI.Level.verbose) test"])
        XCTAssertEqual(logService.entries[.debug], ["\(LogAPI.Level.debug) test"])
        XCTAssertEqual(logService.entries[.info], ["\(LogAPI.Level.info) test"])
        XCTAssertEqual(logService.entries[.warning], ["\(LogAPI.Level.warning) test"])
        XCTAssertEqual(logService.entries[.error], ["\(LogAPI.Level.error) test"])
        XCTAssertEqual(logService.entries[.none], [])
    }
}

extension LoggingTests {
    // swiftlint:disable:next function_body_length
    func testMinLevelsObeyed() {
        // Given
        let verboseService = LogTestService(minLevel: .verbose)
        let debugService = LogTestService(minLevel: .debug)
        let infoService = LogTestService(minLevel: .info)
        let warningService = LogTestService(minLevel: .warning)
        let errorService = LogTestService(minLevel: .error)
        let noneService = LogTestService(minLevel: .none)

        // Then
        XCTAssert(verboseService.canWrite(for: .verbose))
        XCTAssert(verboseService.canWrite(for: .debug))
        XCTAssert(verboseService.canWrite(for: .info))
        XCTAssert(verboseService.canWrite(for: .warning))
        XCTAssert(verboseService.canWrite(for: .error))
        XCTAssertFalse(verboseService.canWrite(for: .none))

        XCTAssertFalse(debugService.canWrite(for: .verbose))
        XCTAssert(debugService.canWrite(for: .debug))
        XCTAssert(debugService.canWrite(for: .info))
        XCTAssert(debugService.canWrite(for: .warning))
        XCTAssert(debugService.canWrite(for: .error))
        XCTAssertFalse(debugService.canWrite(for: .none))

        XCTAssertFalse(infoService.canWrite(for: .verbose))
        XCTAssertFalse(infoService.canWrite(for: .debug))
        XCTAssert(infoService.canWrite(for: .info))
        XCTAssert(infoService.canWrite(for: .warning))
        XCTAssert(infoService.canWrite(for: .error))
        XCTAssertFalse(infoService.canWrite(for: .none))

        XCTAssertFalse(warningService.canWrite(for: .verbose))
        XCTAssertFalse(warningService.canWrite(for: .debug))
        XCTAssertFalse(warningService.canWrite(for: .info))
        XCTAssert(warningService.canWrite(for: .warning))
        XCTAssert(warningService.canWrite(for: .error))
        XCTAssertFalse(warningService.canWrite(for: .none))

        XCTAssertFalse(errorService.canWrite(for: .verbose))
        XCTAssertFalse(errorService.canWrite(for: .debug))
        XCTAssertFalse(errorService.canWrite(for: .info))
        XCTAssertFalse(errorService.canWrite(for: .warning))
        XCTAssert(errorService.canWrite(for: .error))
        XCTAssertFalse(errorService.canWrite(for: .none))

        XCTAssertFalse(noneService.canWrite(for: .verbose))
        XCTAssertFalse(noneService.canWrite(for: .debug))
        XCTAssertFalse(noneService.canWrite(for: .info))
        XCTAssertFalse(noneService.canWrite(for: .warning))
        XCTAssertFalse(noneService.canWrite(for: .error))
        XCTAssertFalse(noneService.canWrite(for: .none))
    }
}

extension LoggingTests {
    func testThreadSafety() {
        // Given
        let promise = expectation(description: #function)
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

        group.notify(queue: .global()) {
            promise.fulfill()
        }

        wait(for: [promise], timeout: 30)

        // Then
        XCTAssertEqual(logService.entries[.verbose]?.count, iterations)
        XCTAssertEqual(logService.entries[.debug]?.count, iterations)
        XCTAssertEqual(logService.entries[.info]?.count, iterations)
        XCTAssertEqual(logService.entries[.warning]?.count, iterations)
        XCTAssertEqual(logService.entries[.error]?.count, iterations)
        XCTAssert(logService.entries[.none]?.isEmpty == true)
    }
}

// MARK: - Mocks

private extension LoggingTests {
    class LogTestService: LogService {
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
            context: [String: CustomStringConvertible]
        ) {
            entries.updateValue(entries[level, default: []] + [message], forKey: level)
        }
    }
}
