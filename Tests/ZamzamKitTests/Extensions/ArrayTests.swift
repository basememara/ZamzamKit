//
//  ArrayTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 10/13/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class ArrayTests: XCTestCase {}

extension ArrayTests {
    func testSafeOutOfBoundsIndex() {
        // Given
        let sample = [1, 3, 5, 7, 9]

        // When
        let result = sample[safe: 4]

        // Then
        XCTAssertEqual(result, 9)
        XCTAssertNil(sample[safe: 99])
    }
}

extension ArrayTests {
    func testPrepend() {
        // Given
        var sample = [2, 3, 4, 5]

        // When
        sample.prepend(1)

        // Then
        XCTAssertEqual(sample, [1, 2, 3, 4, 5])
    }
}

extension ArrayTests {
    func testChunked() {
        XCTAssertEqual([1, 2, 3, 4, 5, 6].chunked(into: 2), [[1, 2], [3, 4], [5, 6]])
        XCTAssertEqual([1, 2, 3, 4].chunked(into: 6), [[1, 2, 3, 4]])
        XCTAssertEqual([String]().chunked(into: 6), [[]])

        XCTAssertEqual(
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].chunked(into: 3),
            [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]
        )

        XCTAssertEqual(
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].chunked(into: 0),
            [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]]
        )

        XCTAssertEqual(
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].chunked(into: 1),
            [[1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]]
        )

        XCTAssertEqual(
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].chunked(into: 12),
            [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]]
        )

        XCTAssertEqual(
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].chunked(into: 11),
            [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], [12]]
        )
    }
}

extension ArrayTests {
    func testRemoveDuplicates() {
        // Given
        let sample = [1, 1, 3, 3, 5, 5, 7, 7, 9, 9]

        // When
        let result = sample.removeDuplicates()

        // Then
        XCTAssertEqual(result, [1, 3, 5, 7, 9])
    }
}

extension ArrayTests {
    func testRemoveElement() {
        // Given
        var sample = ["a", "b", "c", "d", "e", "a"]

        // When
        sample.remove("a")

        // Then
        XCTAssertEqual(sample, ["b", "c", "d", "e", "a"])
    }
}

extension ArrayTests {
    func testIsNilOrEmpty() {
        var test: [String]?

        XCTAssert(test.isNilOrEmpty)

        test = []
        XCTAssert(test.isNilOrEmpty)

        test = ["abc"]
        XCTAssertFalse(test.isNilOrEmpty)
    }
}
