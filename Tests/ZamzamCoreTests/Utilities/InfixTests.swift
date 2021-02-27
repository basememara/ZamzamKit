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
        var someValue: String?

        someProperty ?= someValue
        XCTAssertEqual(someProperty, "abc")

        someValue = "xyz"
        someProperty ?= someValue
        XCTAssertEqual(someProperty, "xyz")

        var test: Int? = 123
        var value: Int?

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
