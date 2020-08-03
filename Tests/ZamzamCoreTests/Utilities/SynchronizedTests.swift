//
//  SynchronizedTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-10-03.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class SynchronizedTests: XCTestCase {
    private let iterations = 10_000 // 1_000_000
    private let writeMultipleOf = 1000
}

extension SynchronizedTests {
    
    func testSharedVariable() {
        DispatchQueue.concurrentPerform(iterations: iterations) { _ in
            Database.shared.set(key: "test", value: true)
        }
    }
    
    private class Database {
        static let shared = Database()
        private var data = Synchronized<[String: Any]>([:])
        
        func get(key: String) -> Any? {
            data.value { $0[key] }
        }
        
        func set(key: String, value: Any) {
            data.value { $0[key] = value }
        }
    }
}

extension SynchronizedTests {
    
    func testWritePerformance() {
        var temp = Synchronized<Int>(0)
     
        measure {
            temp.value { $0 = 0 } // Reset
     
            DispatchQueue.concurrentPerform(iterations: iterations) { _ in
                temp.value { $0 += 1 }
            }
            
            XCTAssertEqual(temp.value, iterations)
        }
    }
}

extension SynchronizedTests {
    
    func testReadPerformance() {
        var temp = Synchronized<Int>(0)
     
        measure {
            temp.value { $0 = 0 } // Reset
     
            DispatchQueue.concurrentPerform(iterations: iterations) {
                guard $0.isMultiple(of: writeMultipleOf) else { return }
                temp.value { $0 += 1 }
            }
            
            XCTAssertGreaterThanOrEqual(temp.value, iterations / writeMultipleOf)
        }
    }
}
