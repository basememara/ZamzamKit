//
//  EquatableTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-05-13.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class EquatableTests: XCTestCase {}
    
extension EquatableTests {
    
    func testWithinSequence() {
        XCTAssert("def".within(["abc", "def", "ghi"]))
        XCTAssert(!"xyz".within(["abc", "def", "ghi"]))
    }
}

extension EquatableTests {
    
    func testCaseIterableIndex() {
        enum Direction: CaseIterable {
            case north
            case east
            case south
            case west
        }
        
        XCTAssertEqual(Direction.north.index(), 0)
        XCTAssertEqual(Direction.east.index(), 1)
        XCTAssertEqual(Direction.south.index(), 2)
        XCTAssertEqual(Direction.west.index(), 3)
    }
}
