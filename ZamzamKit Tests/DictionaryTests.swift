//
//  DictionaryTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 10/13/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import XCTest
@testable import ZamzamKit

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
    
    func testDictionaryUnion() {
        let moreAttributes: [String: String] = ["Function": "authenticate"]
        var attributes: [String: String] = ["File": "Auth.swift"]
        
        // Immutable
        XCTAssertEqual(attributes + moreAttributes + nil, ["Function": "authenticate", "File": "Auth.swift"])
        XCTAssertEqual(attributes + moreAttributes, ["Function": "authenticate", "File": "Auth.swift"])
        XCTAssertEqual(attributes + nil, ["File": "Auth.swift"])
        
        // Mutable
        attributes += nil
        XCTAssertEqual(attributes, ["File": "Auth.swift"])
        
        attributes += moreAttributes
        XCTAssertEqual(attributes, ["File": "Auth.swift", "Function": "authenticate"])
    }
}
