//
//  TestUtilities.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2020-10-04.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import XCTest

extension XCTestCase {
    /// Asserts that all values are equal.
    ///
    /// - Parameters:
    ///   - values: A list of values of type T, where T is Equatable.
    ///   - message: An optional description of the failure.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
    func XCTAssertAllEqual<T: Equatable>(
        _ values: T?...,
        message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        _ = values.reduce(values.first) { current, next in
            XCTAssertEqual(current, next, message(), file: file, line: line)
            return next
        }
    }

    /// Asserts that two values are equal and not nil.
    ///
    /// - Parameters:
    ///   - expression1: An expression of type T, where T is Equatable.
    ///   - values: An expression of type T, where T is Equatable.
    ///   - expression2: An optional description of the failure.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
    func XCTAssertEqualAndNotNil<T: Equatable>(
        _ expression1: @autoclosure () -> T?,
        _ expression2: @autoclosure () -> T?,
        message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertNotNil(expression1(), message(), file: file, line: line)
        XCTAssertNotNil(expression2(), message(), file: file, line: line)
        XCTAssertEqual(expression1(), expression2(), message(), file: file, line: line)
    }
}

// MARK: - Utility Testing

final class UtilitiesTests: XCTestCase {
    func testAssertAllEqual() throws {
        XCTAssertAllEqual(1, 1, 1, 1, 1, 1, 1)
        XCTAssertAllEqual("a", "a", "a", "a", "a")

        // Tested below but must exclude from live test runs
        // XCTAssertAllEqual(1, 1, 1, 2, 1, 1, 1)
    }

    func testAssertEqualAndNotNil() throws {
        XCTAssertEqualAndNotNil(1, 1)

        // Tested below but must exclude from live test runs
        // let value: String? = nil
        // XCTAssertEqualAndNotNil(value, value)
    }
}
