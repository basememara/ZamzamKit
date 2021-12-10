//
//  CaseIterableTests.swift
//  ZamzamCoreTests
//
//  Created by Basem Emara on 2020-03-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class CaseIterableTests: XCTestCase {}

extension CaseIterableTests {
    func testCaseIterablePreviousNext() throws {
        // Given
        enum Direction: CaseIterable {
            case north
            case east
            case south
            case west
        }

        // Then
        XCTAssertNil(Direction.north.previous())
        XCTAssertEqual(Direction.east.previous(), .north)
        XCTAssertEqual(Direction.west.previous(), .south)

        XCTAssertNil(Direction.west.next())
        XCTAssertEqual(Direction.east.next(), .south)
        XCTAssertEqual(Direction.south.next(), .west)
    }
}
