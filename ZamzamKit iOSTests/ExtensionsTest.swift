//
//  ExtensionsTest.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import XCTest
@testable import ZamzamKit

class ExtensionsTest: XCTestCase {
    
    func testEquatableWithin() {
        XCTAssert("def".within(["abc", "def", "ghi"]))
        XCTAssert(!"xyz".within(["abc", "def", "ghi"]))
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
