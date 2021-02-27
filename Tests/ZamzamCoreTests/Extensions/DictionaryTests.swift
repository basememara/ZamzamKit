//
//  DictionaryTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class DictionaryTests: XCTestCase {}

extension DictionaryTests {

    func testIntialValue() throws {
        // Given
        var dictionary = [
            "abc": 123,
            "def": 456,
            "xyz": 789
        ]

        // When
        let value = dictionary["abc", initial: 999]

        XCTAssertNil(dictionary["lmn"])
        let value2 = dictionary["lmn", initial: 555]

        // Then
        XCTAssertAllEqual(dictionary["abc"], value, 123)
        XCTAssertAllEqual(dictionary["lmn"], value2, 555)
    }
}

extension DictionaryTests {

    func testJSONString() throws {
        // Given
        let dictionary: [String: Any] = [
            "id": 1,
            "name": "Joe",
            "friends": [
                [
                    "id": 2,
                    "name": "Pat",
                    "pets": ["dog"]
                ],
                [
                    "id": 3,
                    "name": "Sue",
                    "pets": ["bird", "fish"]
                ]
            ],
            "pets": []
        ]

        let expected: [String: Any]

        // When
        guard let json = dictionary.jsonString() else {
            XCTFail("String could not be converted to JSON")
            return
        }

        guard let data = json.data(using: .utf8),
            let decoded = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                XCTFail("String could not be converted to JSON")
                return
        }

        expected = decoded

        // Then
        XCTAssert(json.contains("\"id\":1"))
        XCTAssert(json.contains("\"name\":\"Joe\""))
        XCTAssert(json.contains("\"friends\":[{"))
        XCTAssert(json.contains("\"pets\":[\"dog\"]"))
        XCTAssert(json.contains("\"name\":\"Sue\""))
        XCTAssert(json.contains("\"pets\":[\""))

        XCTAssertNotNil(dictionary["id"] as? Int)
        XCTAssertEqual(dictionary["id"] as? Int, expected["id"] as? Int)

        XCTAssertNotNil(dictionary["name"] as? String)
        XCTAssertEqual(dictionary["name"] as? String, expected["name"] as? String)

        XCTAssertNotNil(dictionary["pets"] as? [String])
        XCTAssertEqual(dictionary["pets"] as? [String], expected["pets"] as? [String])

        XCTAssertNotNil(((dictionary["friends"] as? [[String: Any]])?.first)?["name"] as? String)
        XCTAssertEqual(
            ((dictionary["friends"] as? [[String: Any]])?.first)?["name"] as? String,
            ((expected["friends"] as? [[String: Any]])?.first)?["name"] as? String
        )
    }
}
