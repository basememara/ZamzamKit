//
//  AtomicTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-10-03.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class AtomicTests: XCTestCase {
    private let iterations = 10_000 // 1_000_000
    private let writeMultipleOf = 1000
}

extension AtomicTests {
    
    func testSharedVariable() {
        DispatchQueue.concurrentPerform(iterations: 10) { _ in
            (0..<iterations).forEach { _ in
                let test = Database.shared.get(key: "test") as? Int ?? 0
                Database.shared.set(key: "test", value: test + 1)
            }
        }
    }
    
    private class Database {
        static let shared = Database()
        private var data = Atomic<[String: Any]>([:])
        
        func get(key: String) -> Any? {
            data.value { $0[key] }
        }
        
        func set(key: String, value: Any) {
            data.value { $0[key] = value }
        }
    }
}

extension AtomicTests {
    
    func testWritePerformance() {
        var temp = Atomic<Int>(0)
     
        measure {
            temp.value { $0 = 0 } // Reset
     
            DispatchQueue.concurrentPerform(iterations: 10) { _ in
                (0..<iterations).forEach { _ in
                    temp.value { $0 += 1 }
                }
            }
            
            XCTAssertEqual(temp.value, iterations * 10)
        }
    }
}

extension AtomicTests {
    
    func testReadPerformance() {
        var temp = Atomic<Int>(0)
     
        measure {
            temp.value { $0 = 0 } // Reset
     
            DispatchQueue.concurrentPerform(iterations: 10) { _ in
                (0..<iterations).forEach {
                    _ = temp
                    guard $0.isMultiple(of: writeMultipleOf) else { return }
                    temp.value { $0 += 1 }
                }
            }
            
            XCTAssertGreaterThanOrEqual(temp.value, iterations / writeMultipleOf)
        }
    }
}
