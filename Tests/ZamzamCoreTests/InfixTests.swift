//
//  InfixTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 4/22/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class InfixTests: XCTestCase {
    
    func testConditionalAssign() {
        var someProperty = "abc"
        var someProperty2: String? = "def"
        var someValue: String?
        
        someProperty ?= someValue
        someProperty2 ?= someValue
        XCTAssertEqual(someProperty, "abc")
        XCTAssertEqual(someProperty2, "def")
        
        someValue = "xyz"
        someProperty ?= someValue
        someProperty2 ?= someValue
        XCTAssertEqual(someProperty, "xyz")
        XCTAssertEqual(someProperty2, "xyz")
        
        var test: Int? = 123
        var value: Int? = nil
        test ?= value
        XCTAssertEqual(test, 123)
        value = 456
        test ?= value
        XCTAssertEqual(test, 456)
    }
}

extension InfixTests {
    
    func testIsNilOrEmptyInfix() {
        var result: String
        var test: String?
        
        result = test ??+ "Abc"
        XCTAssertEqual(result, "Abc")
        
        test = ""
        result = test ??+ "Abc"
        XCTAssertEqual(result, "Abc")
        
        test = "Xyz"
        result = test ??+ "Abc"
        XCTAssertEqual(result, "Xyz")
        
        let test2: String? = "Xyz2"
        let result2 = test2 ??+ nil
        XCTAssertEqual(result2, "Xyz2")
    }
}
