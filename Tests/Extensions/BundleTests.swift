//
//  NSBundleTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 3/4/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct BundleTests {
    private let bundle: Bundle = .module
}

extension BundleTests {
    @Test
    func valuesFromText() {
        let values = bundle.string(file: "Test.txt")

        #expect(values == "This is a test. Abc 123.\n")
    }

    @Test
    func valuesFromPlist() throws {
        let values = bundle.contents(plist: "Settings.plist")

        #expect(values["MyString1"] as? String == "My string value 1.")
        #expect(values["MyNumber1"] as? Int == 123)
        #expect(values["MyBool1"] as? Bool == false)
        #expect(values["MyDate1"] as? Date == Date(
                year: 2016, month: 03, day: 3, hour: 9, minute: 50,
                timeZone: TimeZone(identifier: "America/Toronto")
            ))
    }
}

extension BundleTests {
    @Test
    func arrayFromPlist() {
        let values: [String] = bundle.array(plist: "Array.plist")

        #expect(values[safe: 0] == "Abc")
        #expect(values[safe: 1] == "Def")
        #expect(values[safe: 2] == "Ghi")
    }

    @Test
    func arrayModelsFromPlist() {
        let values: [[String: Any]] = bundle.array(plist: "Things.plist")

        #expect(values[safe: 0]?["id"] as? Int == 1)
        #expect(values[safe: 0]?["name"] as? String == "Test 1")
        #expect(values[safe: 0]?["description"] as? String == "This is a test for 1.")

        #expect(values[safe: 1]?["id"] as? Int == 2)
        #expect(values[safe: 1]?["name"] as? String == "Test 2")
        #expect(values[safe: 1]?["description"] as? String == "This is a test for 2.")

        #expect(values[safe: 2]?["id"] as? Int == 3)
        #expect(values[safe: 2]?["name"] as? String == "Test 3")
        #expect(values[safe: 2]?["description"] as? String == "This is a test for 3.")
    }
}

extension BundleTests {
    @Test
    func arrayInDictionaryFromPlist() {
        let values = bundle.contents(plist: "Settings.plist")
        let array = values["MyArray1"] as? [Any]
        let expected: [Any] = [
            "My string for array value." as Any,
            999 as Any,
            true as Any
        ]

        #expect(array?[safe: 0] as? String == expected[0] as? String)
        #expect(array?[safe: 1] as? Int == expected[1] as? Int)
        #expect(array?[safe: 2] as? Bool == expected[2] as? Bool)
    }

    @Test
    func dictFromPlist() {
        let values = bundle.contents(plist: "Settings.plist")
        let dict = values["MyDictionary1"] as? [String: Any]
        let expected: [String: Any] = [
            "id": 7 as Any,
            "title": "Garden" as Any,
            "active": true as Any
        ]

        #expect(dict?["id"] as? Int == expected["id"] as? Int)
        #expect(dict?["title"] as? String == expected["title"] as? String)
        #expect(dict?["active"] as? Bool == expected["active"] as? Bool)
    }
}
