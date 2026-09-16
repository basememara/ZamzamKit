//
//  TestUtilities.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2020-10-04.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing

/// Asserts that every value is equal to the others.
func expectAllEqual<T: Equatable>(
    _ values: T?...,
    sourceLocation: SourceLocation = #_sourceLocation
) {
    _ = values.reduce(values.first) { current, next in
        #expect(current == next, sourceLocation: sourceLocation)
        return next
    }
}

/// Asserts that two values are non-nil and equal to each other.
func expectEqualAndNotNil<T: Equatable>(
    _ expression1: @autoclosure () -> T?,
    _ expression2: @autoclosure () -> T?,
    sourceLocation: SourceLocation = #_sourceLocation
) {
    let value1 = expression1()
    let value2 = expression2()

    #expect(value1 != nil, sourceLocation: sourceLocation)
    #expect(value2 != nil, sourceLocation: sourceLocation)
    #expect(value1 == value2, sourceLocation: sourceLocation)
}

// MARK: - Utility Testing

struct UtilitiesTests {
    @Test
    func assertAllEqual() {
        expectAllEqual(1, 1, 1, 1, 1, 1, 1)
        expectAllEqual("a", "a", "a", "a", "a")
    }

    @Test
    func assertEqualAndNotNil() {
        expectEqualAndNotNil(1, 1)
    }
}
