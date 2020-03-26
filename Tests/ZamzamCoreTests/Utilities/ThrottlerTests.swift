//
//  ThrottlerTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class ThrottlerTests: XCTestCase {

}

extension ThrottlerTests {
    
    func testThrottler() {
        let limiter = Throttler(limit: 2)
        
        // It should get excuted first
        let promise1 = expectation(description: "Throttler execute 1")
        var reported = limiter.execute {
            promise1.fulfill()
        }
        XCTAssertTrue(reported)
        waitForExpectations(timeout: 0, handler: nil)
        
        // Not right away after
        reported = limiter.execute {
            XCTFail("This shouldn't have run.")
        }
        XCTAssertFalse(reported)
        
        // Sleep for a bit
        sleep(2)
        
        // Now it should get executed
        let promise2 = expectation(description: "Throttler execute 2")
        reported = limiter.execute {
            promise2.fulfill()
        }
        XCTAssertTrue(reported)
        waitForExpectations(timeout: 0, handler: nil)
    }
}

extension ThrottlerTests {
    
    func testThrottler2() {
        let limiter = Throttler(limit: 1)
        
        let promise = expectation(description: "Run once and call immediately")
        var value = 0
        
        limiter.execute {
            value += 1
        }
        
        limiter.execute {
            value += 1
        }
        
        limiter.execute {
            value += 1
        }
        
        limiter.execute {
            value += 1
        }
        
        limiter.execute {
            value += 1
        }
        
        limiter.execute {
            value += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            guard value == 1 else {
                XCTFail("Failed to throttle, calls were not ignored.")
                return
            }
            
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 2)
    }
}

extension ThrottlerTests {
    
    func testThrottler3() {
        let limiter = Throttler(limit: 5)
        
        let promise = expectation(description: "Run once and call immediately")
        var value = 0
        
        limiter.execute {
            value += 1
        }
        
        limiter.execute {
            value += 1
        }
        
        limiter.execute {
            value += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            limiter.execute {
                value += 1
            }
            
            guard value == 2 else {
                XCTFail("Failed to throttle, calls were not ignored.")
                return
            }
            
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
    }
}

extension ThrottlerTests {
    
    func testThrottlerResetting() {
        let limiter = Throttler(limit: 1)
        
        // It should get excuted first
        let promise1 = expectation(description: "Throttler execute 1")
        let reported1 = limiter.execute {
            promise1.fulfill()
        }
        XCTAssertTrue(reported1)
        waitForExpectations(timeout: 0, handler: nil)
        
        // Not right away after
        let reported2 = limiter.execute {
            XCTFail("This shouldn't have run.")
        }
        XCTAssertFalse(reported2)
        
        // Reset limit
        limiter.reset()
        
        // Now it should get executed
        let promise2 = expectation(description: "Throttler execute 2")
        let reported3 = limiter.execute {
            promise2.fulfill()
        }
        XCTAssertTrue(reported3)
        waitForExpectations(timeout: 0, handler: nil)
    }
}
