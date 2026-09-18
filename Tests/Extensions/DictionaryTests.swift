//
//  DictionaryTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct DictionaryTests {}

extension DictionaryTests {
    @Test
    func intialValue() throws {
        // Given
        var dictionary = [
            "abc": 123,
            "def": 456,
            "xyz": 789
        ]

        // When
        let value = dictionary["abc", initial: 999]

        #expect(dictionary["lmn"] == nil)
        let value2 = dictionary["lmn", initial: 555]

        // Then
        expectAllEqual(dictionary["abc"], value, 123)
        expectAllEqual(dictionary["lmn"], value2, 555)
    }
}

extension DictionaryTests {
    @Test
    func jSONString() throws {
        // Given
        let dictionary: [String: Any] = [
            "id": 1,
            "name": "Joe",
            "friends": [
                [
                    "id": 2,
                    "name": "Pat",
                    "pets": ["dog"]
                ] as [String: Any],
                [
                    "id": 3,
                    "name": "Sue",
                    "pets": ["bird", "fish"]
                ] as [String: Any]
            ],
            "pets": [] as [Any]
        ]

        let expected: [String: Any]

        // When
        guard let json = dictionary.jsonString() else {
            Issue.record("String could not be converted to JSON")
            return
        }

        guard let data = json.data(using: .utf8),
            let decoded = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                Issue.record("String could not be converted to JSON")
                return
        }

        expected = decoded

        // Then
        #expect(json.contains("\"id\":1"))
        #expect(json.contains("\"name\":\"Joe\""))
        #expect(json.contains("\"friends\":[{"))
        #expect(json.contains("\"pets\":[\"dog\"]"))
        #expect(json.contains("\"name\":\"Sue\""))
        #expect(json.contains("\"pets\":[\""))

        #expect(dictionary["id"] as? Int != nil)
        #expect(dictionary["id"] as? Int == expected["id"] as? Int)

        #expect(dictionary["name"] as? String != nil)
        #expect(dictionary["name"] as? String == expected["name"] as? String)

        #expect(dictionary["pets"] as? [String] != nil)
        #expect(dictionary["pets"] as? [String] == expected["pets"] as? [String])

        #expect(((dictionary["friends"] as? [[String: Any]])?.first)?["name"] as? String != nil)
        #expect(((dictionary["friends"] as? [[String: Any]])?.first)?["name"] as? String == ((expected["friends"] as? [[String: Any]])?.first)?["name"] as? String)
    }
}
