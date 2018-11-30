//
//  DictionaryTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 10/13/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import XCTest
import ZamzamKit

class DictionaryTests: XCTestCase {
    
}

extension DictionaryTests {
    
    func testRemoveNils() {
        // Given
        var value: [String: Any] = [
            "abc": 123,
            "efd": "xyz",
            "ghi": NSNull(),
            "lmm": true,
            "qrs": NSNull(),
            "tuv": 987
        ]
        
        // When
        value.removeAllNils()
        
        // Then
        XCTAssertTrue(value.count == 4)
        XCTAssertTrue(value.keys.contains("abc"))
        XCTAssertFalse(value.keys.contains("ghi"))
        XCTAssertFalse(value.keys.contains("qrs"))
    }
    
    func testRemoveNils2() {
        // Given
        var value: [String: Any?] = [
            "abc": 123,
            "efd": "xyz",
            "ghi": nil,
            "lmm": true,
            "qrs": nil,
            "tuv": 987
        ]
        
        // When
        value.removeAllNils()
        
        // Then
        XCTAssertTrue(value.count == 4)
        XCTAssertTrue(value.keys.contains("abc"))
        XCTAssertFalse(value.keys.contains("ghi"))
        XCTAssertFalse(value.keys.contains("qrs"))
    }
}

extension DictionaryTests {

    func testJSONString() {
        let value: [String: Any] = [
            "abc": 123,
            "efd": "xyz"
        ]
        
        let json = value.jsonString!
        
        XCTAssertTrue(json.contains("\"abc\":123"))
        XCTAssertTrue(json.contains("\"efd\":\"xyz\""))
    }
}
