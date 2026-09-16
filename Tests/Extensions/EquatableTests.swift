//
//  EquatableTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2019-05-13.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct EquatableTests {}

extension EquatableTests {
    @Test
    func caseIterableIndex() {
        enum Direction: CaseIterable {
            case north
            case east
            case south
            case west
        }

        #expect(Direction.north.index() == 0)
        #expect(Direction.east.index() == 1)
        #expect(Direction.south.index() == 2)
        #expect(Direction.west.index() == 3)
    }
}
