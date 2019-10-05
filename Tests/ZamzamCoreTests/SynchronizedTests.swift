//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-10-03.
//

import XCTest
import ZamzamCore

final class SynchronizedTests: XCTestCase {
    private let iterations = 1_000_000
    private let writeMultipleOf = 1000
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
    
    func testReadPerformance() {
        var temp = Synchronized<Int>(0)
     
        measure {
            temp.value { $0 = 0 } // Reset
     
            DispatchQueue.concurrentPerform(iterations: iterations) {
                XCTAssertGreaterThanOrEqual(temp.value, 0)
                
                if $0.isMultiple(of: writeMultipleOf) {
                    temp.value { $0 += 1 }
                }
            }
            
            XCTAssertGreaterThanOrEqual(temp.value, 0)
        }
    }
}
