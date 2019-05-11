//
//  RateLimiterTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamKit

class RateLimitTests: XCTestCase {

}

// MARK: - Debounce

extension RateLimitTests {
    
    func testDebouncer() {
        let promise = expectation(description: "Debouncer executed")
        let limiter = Debouncer(limit: 1)
        var currentValue = 0
        
        limiter.execute {
            currentValue += 1
        }
        XCTAssertEqual(0, currentValue)
        
        limiter.execute {
            currentValue += 1
        }
        XCTAssertEqual(0, currentValue)
        
        limiter.execute {
            currentValue += 1
            promise.fulfill()
        }
        XCTAssertEqual(0, currentValue)
        
        waitForExpectations(timeout: 2)
        
        XCTAssertEqual(1, currentValue)
        
        // Sleep for a bit
        sleep(2)
        
        let promise2 = expectation(description: "Debouncer execute 2")
        
        limiter.execute {
            currentValue += 1
        }
        XCTAssertEqual(1, currentValue)
        
        limiter.execute {
            currentValue += 1
            promise2.fulfill()
        }
        XCTAssertEqual(1, currentValue)
        
        waitForExpectations(timeout: 2)
        
        XCTAssertEqual(2, currentValue)
    }
    
    func testDebouncer2() {
        let limiter = Debouncer(limit: 5)
        
        let promise = expectation(description: "Run once and call immediately")
        var value = ""
        
        func sendToServer() {
            limiter.execute {
                guard value == "hello" else {
                    XCTFail("Failed to debounce.")
                    return
                }
                
                promise.fulfill()
            }
        }
        
        value.append("h")
        sendToServer()
        
        value.append("e")
        sendToServer()
        
        value.append("l")
        sendToServer()
        
        value.append("l")
        sendToServer()
        
        value.append("o")
        sendToServer()
        
        wait(for: [promise], timeout: 10)
    }
    
    func testDebouncerRunOnceImmediatly() {
        let limiter = Debouncer(limit: 0)
        let promise = expectation(description: "Run once and call immediatly")
        
        limiter.execute {
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 1)
    }
    
    func testDebouncerRunThreeTimesCountTwice() {
        let limiter = Debouncer(limit: 0.5)
        
        let promise = expectation(description: "should fulfill three times")
        promise.expectedFulfillmentCount = 3
        
        limiter.execute {
            promise.fulfill()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            limiter.execute {
                promise.fulfill()
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            limiter.execute {
                promise.fulfill()
            }
        })
        
        wait(for: [promise], timeout: 5)
    }
    
    func testDebouncerRunTwiceCountTwice() {
        let limiter = Debouncer(limit: 1)
        
        let promise = expectation(description: "should fulfill twice")
        promise.expectedFulfillmentCount = 2
        
        limiter.execute {
            promise.fulfill()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            limiter.execute {
                promise.fulfill()
            }
        })
        
        wait(for: [promise], timeout: 3)
    }
    
    func testDebouncerRunTwiceCountOnce() {
        let limiter = Debouncer(limit: 1)
        let promise = expectation(description: "should fullfile once, because calls are both runned immediatly and second one should get ignored")
        promise.expectedFulfillmentCount = 1
        
        limiter.execute {
            promise.fulfill()
        }
        
        limiter.execute {
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
}

// MARK: - Throttle

extension RateLimitTests {
    
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
