//
//  NSBundleTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 3/4/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

class BundleTests: XCTestCase {
    private let bundle: Bundle = .module
}

extension BundleTests {
    func testValuesFromText() {
        let values = bundle.string(file: "Test.txt")

        XCTAssert(values == "This is a test. Abc 123.\n")
    }

    func testValuesFromPlist() throws {
        let values = bundle.contents(plist: "Settings.plist")

        XCTAssertEqual(values["MyString1"] as? String, "My string value 1.")
        XCTAssertEqual(values["MyNumber1"] as? Int, 123)
        XCTAssertEqual(values["MyBool1"] as? Bool, false)
        XCTAssertEqual(
            values["MyDate1"] as? Date,
            Date(
                fromString: "2016/03/03 9:50",
                timeZone: TimeZone(identifier: "America/Toronto")
            )
        )
    }
}

extension BundleTests {
    func testArrayFromPlist() {
        let values: [String] = bundle.array(plist: "Array.plist")

        XCTAssertEqual(values[safe: 0], "Abc")
        XCTAssertEqual(values[safe: 1], "Def")
        XCTAssertEqual(values[safe: 2], "Ghi")
    }

    func testArrayModelsFromPlist() {
        let values: [[String: Any]] = bundle.array(plist: "Things.plist")

        XCTAssertEqual(values[safe: 0]?["id"] as? Int, 1)
        XCTAssertEqual(values[safe: 0]?["name"] as? String, "Test 1")
        XCTAssertEqual(values[safe: 0]?["description"] as? String, "This is a test for 1.")

        XCTAssertEqual(values[safe: 1]?["id"] as? Int, 2)
        XCTAssertEqual(values[safe: 1]?["name"] as? String, "Test 2")
        XCTAssertEqual(values[safe: 1]?["description"] as? String, "This is a test for 2.")

        XCTAssertEqual(values[safe: 2]?["id"] as? Int, 3)
        XCTAssertEqual(values[safe: 2]?["name"] as? String, "Test 3")
        XCTAssertEqual(values[safe: 2]?["description"] as? String, "This is a test for 3.")
    }
}

extension BundleTests {
    func testArrayInDictionaryFromPlist() {
        let values = bundle.contents(plist: "Settings.plist")
        let array = values["MyArray1"] as? [Any]
        let expected: [Any] = [
            "My string for array value." as Any,
            999 as Any,
            true as Any
        ]

        XCTAssertEqual(array?[safe: 0] as? String, expected[0] as? String)
        XCTAssertEqual(array?[safe: 1] as? Int, expected[1] as? Int)
        XCTAssertEqual(array?[safe: 2] as? Bool, expected[2] as? Bool)
    }

    func testDictFromPlist() {
        let values = bundle.contents(plist: "Settings.plist")
        let dict = values["MyDictionary1"] as? [String: Any]
        let expected: [String: Any] = [
            "id": 7 as Any,
            "title": "Garden" as Any,
            "active": true as Any
        ]

        XCTAssertEqual(dict?["id"] as? Int, expected["id"] as? Int)
        XCTAssertEqual(dict?["title"] as? String, expected["title"] as? String)
        XCTAssertEqual(dict?["active"] as? Bool, expected["active"] as? Bool)
    }
}
