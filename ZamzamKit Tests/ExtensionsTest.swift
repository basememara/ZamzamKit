//
//  ExtensionsTest.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamKit

class ExtensionsTest: XCTestCase {
    
    func testEquatableWithin() {
        XCTAssert("def".within(["abc", "def", "ghi"]))
        XCTAssert(!"xyz".within(["abc", "def", "ghi"]))
    }
    
    func testWith() {
        let model = SomeModel().with {
            $0.propertyA = "abc"
            $0.propertyB = 5
            $0.propertyC = true
        }
        
        XCTAssertEqual(model.propertyA, "abc")
        XCTAssertEqual(model.propertyB, 5)
        XCTAssertEqual(model.propertyC, true)
    }
}

class SomeModel {
    var propertyA: String?
    var propertyB: Int?
    var propertyC: Bool?
}

extension SomeModel: With {}
