//
//  CollectionTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 10/13/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import XCTest
import ZamzamKit

class CollectionTests: XCTestCase {

    func testGet() {
        // Given
        let sample = [1, 3, 5, 7, 9]
        
        // When
        let result = sample[safe: 4]
        
        // Then
        XCTAssertEqual(result, 9)
        XCTAssertNil(sample[safe: 99])
    }
}
