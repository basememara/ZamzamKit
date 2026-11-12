//
//  StringTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct StringTests {}

extension StringTests {
    @Test
    func random() {
        #expect(String(random: 10).count == 10)

        let test = String(random: 20, prefix: "TEST: ")
        #expect(test.count == 26)
        #expect(test.hasPrefix("TEST: "))
    }
}

extension StringTests {
    @Test
    func subscripting() {
        let test = "Abcdef123456"

        #expect(test[3] == "d")
        #expect(test[99] == nil)
    }

    @Test
    func subscriptRange() {
        let test = "Abcdef123456"

        #expect(test[11] == "6")
        #expect(test[3...6] == "def1")
        #expect(test[3...99] == "def123456")
        #expect(test[11...199] == "6")
        #expect(test[12...199] == nil)
        #expect(test[3..<6] == "def")
        #expect(test.dropFirst(3) == "def123456")
    }
}

extension StringTests {
    @Test
    func trimmed() {
        let test = " Abcdef123456 \n\r  "
        let expected = "Abcdef123456"
        #expect(test.trimmed == expected)
    }

    @Test
    func truncated() {
        let test = "Abcdef123456"
        #expect(test.truncated(3) == "Abc...")
        #expect(test.truncated(3, trailing: "***") == "Abc***")
    }

    @Test
    func truncatOutOfRange() {
        let test = "Abcdef123456"
        #expect(test.truncated(20) == test)
    }

    @Test
    func separator() {
        #expect("Abcdef123456".separated(every: 3, with: "-") == "Abc-def-123-456")
        #expect("Abcd".separated(every: 6, with: ":") == "Abcd")
        #expect("Abcdef123456".separated(every: 0, with: "-") == "Abcdef123456")
        #expect("Abcdef123456".separated(every: 1, with: "-") == "A-b-c-d-e-f-1-2-3-4-5-6")
        #expect("Abcdef123456".separated(every: 12, with: "-") == "Abcdef123456")
        #expect("Abcdef123456".separated(every: 11, with: "-") == "Abcdef12345-6")
        #expect("".separated(every: 6, with: ":").isEmpty)
        #expect("112312451".separated(every: 2, with: ":") == "11:23:12:45:1")
        #expect("112312451".separated(every: 3, with: ":") == "112:312:451")
        #expect("112312451".separated(every: 4, with: ":") == "1123:1245:1")
    }

    @Test
    func strippingWhitespaceAndNewlines() {
        let string = """
            { 0         1
            2                  34
            56       7             8
            9
            }
            """

        #expect(string.strippingCharacters(in: .whitespacesAndNewlines) == "{0123456789}")
    }

    @Test
    func replacingCharacters() {
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: "_")
        let disallowed = allowed.inverted

        let string = """
            _abcdefghijklmnopqrstuvwxyz
            ABCDEFGHIJKLMNOPQRSTUVWXYZ
            0{1 2<3>4@5#6`7~8?9,0

            1
            """

        #expect(string.replacingCharacters(in: disallowed, with: "_") == "_abcdefghijklmnopqrstuvwxyz_ABCDEFGHIJKLMNOPQRSTUVWXYZ_0_1_2_3_4_5_6_7_8_9_0__1")
    }
}

extension StringTests {
    @Test
    func replacingLastOccurrence() {
        #expect("fghijklmnopqrstuvwxyz_ABCDE".replacingLastOccurrence(of: "_ABCDE", with: "ZYX_") == "fghijklmnopqrstuvwxyzZYX_")

        #expect("{1 22<3>2224@5#226`27~8".replacingLastOccurrence(of: "2", with: "_") == "{1 22<3>2224@5#226`_7~8")

        #expect("aaabbbccc".replacingLastOccurrence(of: "c", with: "d") == "aaabbbccd")

        #expect("aaabbbccc".replacingLastOccurrence(of: "b", with: "y") == "aaabbyccc")

        #expect("aaabbbccc".replacingLastOccurrence(of: "a", with: "z") == "aazbbbccc")

        #expect("aaabbbccc".replacingLastOccurrence(of: "bb", with: "123") == "aaab123ccc")
    }
}

extension StringTests {
    @Test
    func decodeDictionaryString() throws {
        let expected: [String: String] = [
            "test1": "abc",
            "test2": "def",
            "test3": "ghi",
            "test4": "jkl",
            "test5": "mno",
            "test6": "prs"
        ]

        let data = try JSONEncoder().encode(expected)

        guard let json = String(data: data, encoding: .utf8) else {
            Issue.record("Could not encode value for testing")
            return
        }

        #expect(try json.decode() == expected)
    }

    @Test
    func decodeDictionaryDouble() throws {
        let expected: [String: Double] = [
            "abc": 1.4,
            "def": 0.23,
            "ghi": 53.221,
            "jkl": 232.23,
            "mno": 745,
            "prs": 325.235
        ]

        let data = try JSONEncoder().encode(expected)

        guard let json = String(data: data, encoding: .utf8) else {
            Issue.record("Could not encode value for testing")
            return
        }

        #expect(try json.decode() == expected)
    }

    @Test
    func decodeDictionaryBool() throws {
        let expected: [Int: Bool] = [
            1: true,
            3: false,
            4: true,
            5: true,
            8: false,
            9: true
        ]

        let data = try JSONEncoder().encode(expected)

        guard let json = String(data: data, encoding: .utf8) else {
            Issue.record("Could not encode value for testing")
            return
        }

        #expect(try json.decode() == expected)
    }

    @Test
    func decodeDictionaryInt() throws {
        let test = "{\"test1\":29,\"test2\":62,\"test3\":33,\"test4\":24,\"test5\":14,\"test6\":72}"
        let expected: [String: Int] = [
            "test1": 29,
            "test2": 62,
            "test3": 33,
            "test4": 24,
            "test5": 14,
            "test6": 72
        ]

        #expect(try test.decode() == expected)
    }
}

extension StringTests {
    @Test
    func base64Encoded() {
        let test = "Abcdef123456"
        let expected = "QWJjZGVmMTIzNDU2"
        #expect(test.base64Encoded() == expected)
    }

    @Test
    func base64URLEncoded() {
        let test = "dsva-kjKH IU_H78yds8/7fyt78O TD+SY*O&*&T*A&(A*SF Y d8=q933827 z*&T*(ui sda ds"
        let expected = "ZHN2YS1raktIIElVX0g3OHlkczgvN2Z5dDc4TyBURCtTWSpPJiomVCpBJihBKlNGIFkgZDg9cTkzMzgyNyB6KiZUKih1aSBzZGEgZHM"
        #expect(test.base64URLEncoded() == expected)
    }

    @Test
    func base64Decoded() {
        let test = "NjU0MzIxRmVkY2Jh"
        let expected = "654321Fedcba"
        #expect(test.base64Decoded() == expected)
    }
}

extension StringTests {
    @Test
    func isNilOrEmpty() {
        var test: String?

        #expect(test.isNilOrEmpty)

        test = ""
        #expect(test.isNilOrEmpty)

        test = "abc"
        #expect(!(test.isNilOrEmpty))
    }

    @Test
    func isNilOrBlank() {
        var test: String?

        #expect(test.isNilOrBlank)

        test = ""
        #expect(test.isNilOrBlank)

        test = "     "
        #expect(test.isNilOrBlank)

        test = "abc"
        #expect(!(test.isNilOrBlank))
    }
}
