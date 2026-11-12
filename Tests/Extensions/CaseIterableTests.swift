//
//  CaseIterableTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2020-03-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct CaseIterableTests {}

extension CaseIterableTests {
    @Test
    func caseIterablePreviousNext() throws {
        // Given
        enum Direction: CaseIterable {
            case north
            case east
            case south
            case west
        }

        // Then
        #expect(Direction.north.previous() == nil)
        #expect(Direction.east.previous() == .north)
        #expect(Direction.west.previous() == .south)

        #expect(Direction.west.next() == nil)
        #expect(Direction.east.next() == .south)
        #expect(Direction.south.next() == .west)
    }

    @Test
    func previousAndNextStopAtTheEndsOfAnyCollectionOfCases() {
        // Given
        struct Even: CaseIterable, Equatable {
            static var allCases: LazyFilterCollection<[Even]> {
                (0...6).map(Even.init).lazy.filter { $0.number.isMultiple(of: 2) }
            }

            let number: Int
        }

        // Then
        #expect(Even(number: 0).previous() == nil)
        #expect(Even(number: 2).previous() == Even(number: 0))
        #expect(Even(number: 4).next() == Even(number: 6))
        #expect(Even(number: 6).next() == nil)
    }
}
