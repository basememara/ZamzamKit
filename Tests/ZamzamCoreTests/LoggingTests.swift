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

final class LoggingTests: XCTestCase {
    
}

extension LoggingTests {
    
    func testEntriesAreWritten() {
        // Given
        let promise = expectation(description: "testEntriesAreWritten")
        let logStore = LogTestStore(minLevel: .verbose)
        let log: LogWorkerType = LogWorker(stores: [logStore])
        let group = DispatchGroup()
        
        // When
        LogAPI.Level.allCases.forEach {
            group.enter()
            
            log.write($0, with: "\($0) test", path: #file, function: #function, line: #line, context: nil) {
                group.leave()
            }
        }
        
        // Then
        group.notify(queue: .global()) {
            XCTAssertEqual(logStore.entries[.verbose], ["\(LogAPI.Level.verbose) test"])
            XCTAssertEqual(logStore.entries[.debug], ["\(LogAPI.Level.debug) test"])
            XCTAssertEqual(logStore.entries[.info], ["\(LogAPI.Level.info) test"])
            XCTAssertEqual(logStore.entries[.warning], ["\(LogAPI.Level.warning) test"])
            XCTAssertEqual(logStore.entries[.error], ["\(LogAPI.Level.error) test"])
            XCTAssertEqual(logStore.entries[.none], [])
            
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
    }
}

extension LoggingTests {
    
    func testMinLevelsObeyed() {
        // Given
        let verboseStore = LogTestStore(minLevel: .verbose)
        let debugStore = LogTestStore(minLevel: .debug)
        let infoStore = LogTestStore(minLevel: .info)
        let warningStore = LogTestStore(minLevel: .warning)
        let errorStore = LogTestStore(minLevel: .error)
        let noneStore = LogTestStore(minLevel: .none)
        
        // Then
        XCTAssert(verboseStore.canWrite(for: .verbose))
        XCTAssert(verboseStore.canWrite(for: .debug))
        XCTAssert(verboseStore.canWrite(for: .info))
        XCTAssert(verboseStore.canWrite(for: .warning))
        XCTAssert(verboseStore.canWrite(for: .error))
        XCTAssertFalse(verboseStore.canWrite(for: .none))
        
        XCTAssertFalse(debugStore.canWrite(for: .verbose))
        XCTAssert(debugStore.canWrite(for: .debug))
        XCTAssert(debugStore.canWrite(for: .info))
        XCTAssert(debugStore.canWrite(for: .warning))
        XCTAssert(debugStore.canWrite(for: .error))
        XCTAssertFalse(debugStore.canWrite(for: .none))
        
        XCTAssertFalse(infoStore.canWrite(for: .verbose))
        XCTAssertFalse(infoStore.canWrite(for: .debug))
        XCTAssert(infoStore.canWrite(for: .info))
        XCTAssert(infoStore.canWrite(for: .warning))
        XCTAssert(infoStore.canWrite(for: .error))
        XCTAssertFalse(infoStore.canWrite(for: .none))
        
        XCTAssertFalse(warningStore.canWrite(for: .verbose))
        XCTAssertFalse(warningStore.canWrite(for: .debug))
        XCTAssertFalse(warningStore.canWrite(for: .info))
        XCTAssert(warningStore.canWrite(for: .warning))
        XCTAssert(warningStore.canWrite(for: .error))
        XCTAssertFalse(warningStore.canWrite(for: .none))
        
        XCTAssertFalse(errorStore.canWrite(for: .verbose))
        XCTAssertFalse(errorStore.canWrite(for: .debug))
        XCTAssertFalse(errorStore.canWrite(for: .info))
        XCTAssertFalse(errorStore.canWrite(for: .warning))
        XCTAssert(errorStore.canWrite(for: .error))
        XCTAssertFalse(errorStore.canWrite(for: .none))
        
        XCTAssertFalse(noneStore.canWrite(for: .verbose))
        XCTAssertFalse(noneStore.canWrite(for: .debug))
        XCTAssertFalse(noneStore.canWrite(for: .info))
        XCTAssertFalse(noneStore.canWrite(for: .warning))
        XCTAssertFalse(noneStore.canWrite(for: .error))
        XCTAssertFalse(noneStore.canWrite(for: .none))
    }
}

extension LoggingTests {
    
    func testThreadSafety() {
        // Given
        let promise = expectation(description: "testThreadSafety")
        let logStore = LogTestStore(minLevel: .verbose)
        let log: LogWorkerType = LogWorker(stores: [logStore])
        let group = DispatchGroup()
        let iterations = 1_000 // 10_000
        
        // When
        DispatchQueue.concurrentPerform(iterations: iterations) { iteration in
            LogAPI.Level.allCases.forEach {
                group.enter()
                
                log.write($0, with: "\($0) test \(iteration)", path: #file, function: #function, line: #line, context: nil) {
                    group.leave()
                }
            }
        }
        
        // Then
        group.notify(queue: .global()) {
            XCTAssertEqual(logStore.entries[.verbose]?.count, iterations)
            XCTAssertEqual(logStore.entries[.debug]?.count, iterations)
            XCTAssertEqual(logStore.entries[.info]?.count, iterations)
            XCTAssertEqual(logStore.entries[.warning]?.count, iterations)
            XCTAssertEqual(logStore.entries[.error]?.count, iterations)
            XCTAssert(logStore.entries[.none]?.isEmpty == true)
            
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 30)
    }
}

private extension LoggingTests {
    
    class LogTestStore: LogStore {
        let minLevel: LogAPI.Level
        
        init(minLevel: LogAPI.Level) {
            self.minLevel = minLevel
        }
        
        // Spy
        var entries = Dictionary(
            uniqueKeysWithValues: LogAPI.Level.allCases.map { ($0, [String]()) }
        )
        
        func write(_ level: LogAPI.Level, with message: String, path: String, function: String, line: Int, context: [String: Any]?) {
            entries.updateValue(entries[level, default: []] + [message], forKey: level)
        }
    }
}
