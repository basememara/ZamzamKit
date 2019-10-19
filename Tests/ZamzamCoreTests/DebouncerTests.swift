//
//  RateLimiterTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class DebouncerTests: XCTestCase {

}

extension DebouncerTests {
    
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
}

extension DebouncerTests {
    
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
}

extension DebouncerTests {
    
    func testDebouncerRunOnceImmediatly() {
        let limiter = Debouncer(limit: 0)
        let promise = expectation(description: "Run once and call immediatly")
        
        limiter.execute {
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 1)
    }
}

extension DebouncerTests {
    
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
}

extension DebouncerTests {
    
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
}

extension DebouncerTests {
    
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
