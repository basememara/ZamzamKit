//
//  DictionaryTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 10/13/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamKit

class DictionaryTests: XCTestCase {
    
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
