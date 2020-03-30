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
    
    func testDistinct() {
        // Given
        let sample = [1, 1, 3, 3, 5, 5, 7, 7, 9, 9]
        
        // When
        let result = sample.distinct
        
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
