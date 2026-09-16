//
//  ArrayTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 10/13/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct ArrayTests {}

extension ArrayTests {
    @Test
    func safeOutOfBoundsIndex() {
        // Given
        let sample = [1, 3, 5, 7, 9]

        // When
        let result = sample[safe: 4]

        // Then
        #expect(result == 9)
        #expect(sample[safe: 99] == nil)
    }
}

extension ArrayTests {
    @Test
    func prepend() {
        // Given
        var sample = [2, 3, 4, 5]

        // When
        sample.prepend(1)

        // Then
        #expect(sample == [1, 2, 3, 4, 5])
    }
}

extension ArrayTests {
    @Test
    func chunked() {
        #expect([1, 2, 3, 4, 5, 6].chunked(into: 2) == [[1, 2], [3, 4], [5, 6]])
        #expect([1, 2, 3, 4].chunked(into: 6) == [[1, 2, 3, 4]])
        #expect([String]().chunked(into: 6) == [[]])

        #expect([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].chunked(into: 3) == [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]])

        #expect([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].chunked(into: 0) == [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]])

        #expect([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].chunked(into: 1) == [[1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]])

        #expect([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].chunked(into: 12) == [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]])

        #expect([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].chunked(into: 11) == [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], [12]])
    }
}

extension ArrayTests {
    @Test
    func removeDuplicates() {
        // Given
        let sample = [1, 1, 3, 3, 5, 5, 7, 7, 9, 9]

        // When
        let result = sample.removeDuplicates()

        // Then
        #expect(result == [1, 3, 5, 7, 9])
    }
}

extension ArrayTests {
    @Test
    func removeElement() {
        // Given
        var sample = ["a", "b", "c", "d", "e", "a"]

        // When
        sample.remove("a")

        // Then
        #expect(sample == ["b", "c", "d", "e", "a"])
    }
}

extension ArrayTests {
    @Test
    func isNilOrEmpty() {
        var test: [String]?

        #expect(test.isNilOrEmpty)

        test = []
        #expect(test.isNilOrEmpty)

        test = ["abc"]
        #expect(!(test.isNilOrEmpty))
    }
}
