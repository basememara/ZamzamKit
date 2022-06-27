//
//  LimiterTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2022-04-04.
//  Copyright © 2022 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class LimiterTests: XCTestCase {}

extension LimiterTests {
    func testThrottler() async throws {
        // Given
        let promise = expectation(description: "Ensure first task fired")
        let throttler = Limiter(policy: .throttle, duration: 1)
        var value = ""

        var fulfillmentCount = 0
        promise.expectedFulfillmentCount = 2

        func sendToServer(_ input: String) async {
            await throttler.run {
                value += input

                // Then
                switch fulfillmentCount {
                case 0:
                    XCTAssertEqual(value, "h")
                case 1:
                    XCTAssertEqual(value, "hwor")
                default:
                    XCTFail()
                }

                promise.fulfill()
                fulfillmentCount += 1
            }
        }

        // When
        await sendToServer("h")
        await sendToServer("e")
        await sendToServer("l")
        await sendToServer("l")
        await sendToServer("o")

        try await Task.sleep(seconds: 2)

        await sendToServer("wor")
        await sendToServer("ld")

        wait(for: [promise], timeout: 10)
    }
}

extension LimiterTests {
    func testDebouncer() async throws {
        // Given
        let promise = expectation(description: "Ensure last task fired")
        let debouncer = Limiter(policy: .debounce, duration: 1)
        var value = ""

        var fulfillmentCount = 0
        promise.expectedFulfillmentCount = 2

        func sendToServer(_ input: String) async {
            await debouncer.run {
                value += input

                // Then
                switch fulfillmentCount {
                case 0:
                    XCTAssertEqual(value, "o")
                case 1:
                    XCTAssertEqual(value, "old")
                default:
                    XCTFail()
                }

                promise.fulfill()
                fulfillmentCount += 1
            }
        }

        // When
        await sendToServer("h")
        await sendToServer("e")
        await sendToServer("l")
        await sendToServer("l")
        await sendToServer("o")

        try await Task.sleep(seconds: 2)

        await sendToServer("wor")
        await sendToServer("ld")

        wait(for: [promise], timeout: 10)
    }
}

extension LimiterTests {
    func testThrottler2() async throws {
        // Given
        let promise = expectation(description: "Ensure throttle before duration")
        let throttler = Limiter(policy: .throttle, duration: 1)

        var end = Date.now + 1
        promise.expectedFulfillmentCount = 2

        func test() {
            // Then
            XCTAssertLessThanOrEqual(.now, end)
            promise.fulfill()
        }

        // When
        await throttler.run(test)
        await throttler.run(test)
        await throttler.run(test)
        await throttler.run(test)
        await throttler.run(test)

        try await Task.sleep(seconds: 2)
        end = .now + 1

        await throttler.run(test)
        await throttler.run(test)
        await throttler.run(test)

        try await Task.sleep(seconds: 2)

        wait(for: [promise], timeout: 10)
    }
}

extension LimiterTests {
    func testDebouncer2() async throws {
        // Given
        let promise = expectation(description: "Ensure debounce after duration")
        let debouncer = Limiter(policy: .debounce, duration: 1)

        var end = Date.now + 1
        promise.expectedFulfillmentCount = 2

        func test() {
            // Then
            XCTAssertGreaterThanOrEqual(.now, end)
            promise.fulfill()
        }

        // When
        await debouncer.run(test)
        await debouncer.run(test)
        await debouncer.run(test)
        await debouncer.run(test)
        await debouncer.run(test)

        try await Task.sleep(seconds: 2)
        end = .now + 1

        await debouncer.run(test)
        await debouncer.run(test)
        await debouncer.run(test)

        try await Task.sleep(seconds: 2)

        wait(for: [promise], timeout: 10)
    }
}
