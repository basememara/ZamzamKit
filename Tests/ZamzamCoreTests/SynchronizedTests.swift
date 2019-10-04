//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-10-03.
//

import XCTest
import ZamzamCore

final class SynchronizedTests: XCTestCase {
    
}

extension SynchronizedTests {
    
    func testLockPerformance() {
        var temp = Synchronized<Int>(0)

        measure {
            temp.value { $0 = 0 } // Reset
            
            DispatchQueue.concurrentPerform(iterations: 1_000_000) { _ in
                temp.value { $0 += 1 }
            }
            
            XCTAssertEqual(temp.value, 1_000_000)
        }
    }
}
