//
//  ArrayTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 10/13/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import XCTest
@testable import ZamzamKit

class ArrayTests: XCTestCase {

    let sample1 = [1, 3, 5, 7, 9, 11, 13, 15, 17, 21]
    let sample2 = [
        (a: "Item 1", b: "F", c: 3),
        (a: "Item 2", b: "S", c: 5),
        (a: "Item 3", b: "D", c: 7),
        (a: "Item 4", b: "A", c: 9),
        (a: "Item 5", b: "M", c: 11),
        (a: "Item 6", b: "I", c: 13),
        (a: "Item 7", b: "F", c: 15),
        (a: "Item 8", b: "S", c: 17),
        (a: "Item 9", b: "D", c: 19),
        (a: "Item 10", b: "A", c: 21),
        (a: "Item 11", b: "M", c: 23),
        (a: "Item 12", b: "I", c: 13),
        (a: "Item 13", b: "F", c: 15),
        (a: "Item 14", b: "S", c: 17),
        (a: "Item 15", b: "D", c: 19),
        (a: "Item 16", b: "A", c: 21),
        (a: "Item 17", b: "M", c: 23),
        (a: "Item 18", b: "I", c: 13),
        (a: "Item 19", b: "F", c: 15),
        (a: "Item 20", b: "S", c: 17),
        (a: "Item 21", b: "D", c: 19),
        (a: "Item 22", b: "A", c: 21),
        (a: "Item 23", b: "M", c: 23),
        (a: "Item 24", b: "I", c: 13)
    ]

    func testGet() {
        let result = sample1.get(5)
        let expected = 11
        
        XCTAssertEqual(result, expected,
            "Get should be \(expected)")
        
        XCTAssertNil(sample1.get(99),
            "Get should be nil")
    }

    func testRemoveEach() {
        var result = sample2
        
        result.removeEach { print($0.a) }
        
        XCTAssert(result.isEmpty,
            "Result should be empty")
    }
}

extension ArrayTests {

    func testRandom() {
        let result = sample1.random()
        XCTAssert(sample1.contains(result))
    }
    
    func testShuffled() {
        let original = [1, 2, 3, 4, 5]
        var array = original
        
        while original == array {
            array = array.shuffled()
        }
        XCTAssertEqual(array.count, 5)
        XCTAssertNotEqual(original, array)
    }
}
