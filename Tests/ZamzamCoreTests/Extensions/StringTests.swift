//
//  StringHelper.swift
//  ZamzamCore
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class StringTests: XCTestCase {
    
}

extension StringTests {
    
    func testRandom() {
        XCTAssertEqual(String(random: 10).count, 10)
        
        let test = String(random: 20, prefix: "TEST: ")
        XCTAssertEqual(test.count, 26)
        XCTAssertTrue(test.hasPrefix("TEST: "))
    }
}

extension StringTests {
    
    func testSubscript() {
        let test = "Abcdef123456"
        
        XCTAssertEqual(test[3], "d")
        XCTAssertNil(test[99])
    }
    
    func testSubscriptRange() {
        let test = "Abcdef123456"
        
        XCTAssertEqual(test[3...6], "def1")
        XCTAssertEqual(test[3...99], nil)
        XCTAssertEqual(test[3..<6], "def")
        XCTAssertEqual(test[3...], "def123456")
    }
}

extension StringTests {
    
    func testEmailRegEx() {
        let value = "test@example.com"
        let wrong = "zamzam"
        
        XCTAssertTrue(value.isEmail)
        XCTAssertFalse(wrong.isEmail)
    }
    
    func testNumberRegEx() {
        let value = "123456789"
        let wrong = "zamzam"
        
        XCTAssertTrue(value.isNumber)
        XCTAssertFalse(wrong.isNumber)
    }
    
    func testAlphaRegEx() {
        let value = "zamzam"
        let wrong = "zamzam123"
        
        XCTAssertTrue(value.isAlpha)
        XCTAssertFalse(wrong.isAlpha)
    }
    
    func testAlphaNumbericRegEx() {
        let value = "zamzam123"
        let wrong = "zamzam!"
        
        XCTAssertTrue(value.isAlphaNumeric)
        XCTAssertFalse(wrong.isAlphaNumeric)
    }
}

extension StringTests {
    
    func testTrimmed() {
        let test = " Abcdef123456 \n\r  "
        let expected = "Abcdef123456"
        XCTAssertEqual(test.trimmed, expected)
    }
    
    func testTruncated() {
        let test = "Abcdef123456"
        XCTAssertEqual(test.truncated(3), "Abc...")
        XCTAssertEqual(test.truncated(3, trailing: "***"), "Abc***")
    }
    
    func testTruncatOutOfRange() {
        let test = "Abcdef123456"
        XCTAssertEqual(test.truncated(20), test)
    }
    
    func testContains() {
        let elements = CharacterSet(charactersIn: "AbCz456!")
        
        XCTAssertFalse("".contains(elements))
        XCTAssertTrue("Foo5".contains(elements))
        XCTAssertTrue("bar 222".contains(elements))
        XCTAssertFalse("none".contains(elements))
        XCTAssertFalse("999".contains(elements))
        XCTAssertFalse("#$23".contains(elements))
        XCTAssertTrue("qwe!".contains(elements))
        
        XCTAssertTrue("def".contains(CharacterSet(charactersIn: "Abcdef123456")))
        XCTAssertFalse("Xyz".contains(CharacterSet(charactersIn: "Abcdef123456")))
    }
    
    func testSeparator() {
        XCTAssertEqual("Abcdef123456".separated(every: 3, with: "-"), "Abc-def-123-456")
        XCTAssertEqual("Abcd".separated(every: 6, with: ":"), "Abcd")
        XCTAssertEqual("Abcdef123456".separated(every: 0, with: "-"), "Abcdef123456")
        XCTAssertEqual("Abcdef123456".separated(every: 1, with: "-"), "A-b-c-d-e-f-1-2-3-4-5-6")
        XCTAssertEqual("Abcdef123456".separated(every: 12, with: "-"), "Abcdef123456")
        XCTAssertEqual("Abcdef123456".separated(every: 11, with: "-"), "Abcdef12345-6")
        XCTAssertEqual("".separated(every: 6, with: ":"), "")
        XCTAssertEqual("112312451".separated(every: 2, with: ":"), "11:23:12:45:1")
        XCTAssertEqual("112312451".separated(every: 3, with: ":"), "112:312:451")
        XCTAssertEqual("112312451".separated(every: 4, with: ":"), "1123:1245:1")
    }
    
    func testStrippingWhitespaceAndNewlines() {
        let string = """
            { 0         1
            2                  34
            56       7             8
            9
            }
            """
        
        XCTAssertEqual(
            string.strippingCharacters(in: .whitespacesAndNewlines),
            "{0123456789}"
        )
    }
    
    func testReplacingCharacters() {
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: "_")
        let disallowed = allowed.inverted
        
        let string = """
            _abcdefghijklmnopqrstuvwxyz
            ABCDEFGHIJKLMNOPQRSTUVWXYZ
            0{1 2<3>4@5#6`7~8?9,0

            1
            """
        
        XCTAssertEqual(
            string.replacingCharacters(in: disallowed, with: "_"),
            "_abcdefghijklmnopqrstuvwxyz_ABCDEFGHIJKLMNOPQRSTUVWXYZ_0_1_2_3_4_5_6_7_8_9_0__1"
        )
    }
}

extension StringTests {
    
    func testReplacingLastOccurrence() {
        XCTAssertEqual(
            "fghijklmnopqrstuvwxyz_ABCDE".replacingLastOccurrence(of: "_ABCDE", with: "ZYX_"),
            "fghijklmnopqrstuvwxyzZYX_"
        )
        
        XCTAssertEqual(
            "{1 22<3>2224@5#226`27~8".replacingLastOccurrence(of: "2", with: "_"),
            "{1 22<3>2224@5#226`_7~8"
        )
        
        XCTAssertEqual(
            "aaabbbccc".replacingLastOccurrence(of: "c", with: "d"),
            "aaabbbccd"
        )
        
        XCTAssertEqual(
            "aaabbbccc".replacingLastOccurrence(of: "b", with: "y"),
            "aaabbyccc"
        )
        
        XCTAssertEqual(
            "aaabbbccc".replacingLastOccurrence(of: "a", with: "z"),
            "aazbbbccc"
        )
        
        XCTAssertEqual(
            "aaabbbccc".replacingLastOccurrence(of: "bb", with: "123"),
            "aaab123ccc"
        )
    }
}

extension StringTests {
    
    func testMatchRegEx() {
        XCTAssertTrue("1234567890".match(regex: "^[0-9]+?$"))
        XCTAssertTrue("abc123xyz".match(regex: "^[A-Za-z0-9]+$"))
        XCTAssertFalse("abc123xyz".match(regex: "^[A-Za-z]+$"))
    }
    
    func testReplacingRegEx() {
        let value = "my car reg 1 - dD11 AAA  my car reg 2 - AA22 BbB"
        let pattern = "([A-HK-PRSVWY][A-HJ-PR-Y])\\s?([0][2-9]|[1-9][0-9])\\s?[A-HJ-PR-Z]{3}"
        
        // Case insensitive
        let newValue = value.replacing(regex: pattern, with: "XX", caseSensitive: false)
        let expectedValue = "my car reg 1 - XX  my car reg 2 - XX"
        XCTAssertEqual(newValue, expectedValue)
        
        // Case sensitive
        let newValue2 = value.replacing(regex: pattern, with: "XX", caseSensitive: true)
        XCTAssertEqual(newValue2, value)
        
        XCTAssertEqual("aa1bb22cc3d888d4ee5".replacing(regex: "\\d", with: "*"), "aa*bb**cc*d***d*ee*")
    }
}

extension StringTests {
    
    func testDecodeDictionaryString() {
        let expected: [String: String] = [
            "test1": "abc",
            "test2": "def",
            "test3": "ghi",
            "test4": "jkl",
            "test5": "mno",
            "test6": "prs"
        ]
        
        guard let data = try? JSONEncoder().encode(expected),
            let json = String(data: data, encoding: .utf8) else {
                XCTFail("Could not encode value for testing")
                return
        }
        
        XCTAssertEqual(json.decode(), expected)
    }
    
    func testDecodeDictionaryDouble() {
        let expected: [String: Double] = [
            "abc": 1.4,
            "def": 0.23,
            "ghi": 53.221,
            "jkl": 232.23,
            "mno": 745,
            "prs": 325.235
        ]
        
        guard let data = try? JSONEncoder().encode(expected),
            let json = String(data: data, encoding: .utf8) else {
                XCTFail("Could not encode value for testing")
                return
        }
        
        XCTAssertEqual(json.decode(), expected)
    }
    
    func testDecodeDictionaryBool() {
        let expected: [Int: Bool] = [
            1: true,
            3: false,
            4: true,
            5: true,
            8: false,
            9: true
        ]
        
        guard let data = try? JSONEncoder().encode(expected),
            let json = String(data: data, encoding: .utf8) else {
                XCTFail("Could not encode value for testing")
                return
        }
        
        XCTAssertEqual(json.decode(), expected)
    }
    
    func testDecodeDictionaryInt() {
        let test = "{\"test1\":29,\"test2\":62,\"test3\":33,\"test4\":24,\"test5\":14,\"test6\":72}"
        let expected: [String: Int] = [
            "test1": 29,
            "test2": 62,
            "test3": 33,
            "test4": 24,
            "test5": 14,
            "test6": 72
        ]
        
        XCTAssertEqual(test.decode(), expected)
    }
}

extension StringTests {
    
    func testBase64Encoded() {
        let test = "Abcdef123456"
        let expected = "QWJjZGVmMTIzNDU2"
        XCTAssertEqual(test.base64Encoded(), expected)
    }
    
    func testBase64URLEncoded() {
        let test = "dsva-kjKH IU_H78yds8/7fyt78O TD+SY*O&*&T*A&(A*SF Y d8=q933827 z*&T*(ui sda ds"
        let expected = "ZHN2YS1raktIIElVX0g3OHlkczgvN2Z5dDc4TyBURCtTWSpPJiomVCpBJihBKlNGIFkgZDg9cTkzMzgyNyB6KiZUKih1aSBzZGEgZHM"
        XCTAssertEqual(test.base64URLEncoded(), expected)
    }
    
    func testBase64Decoded() {
        let test = "NjU0MzIxRmVkY2Jh"
        let expected = "654321Fedcba"
        XCTAssertEqual(test.base64Decoded(), expected)
    }
}

extension StringTests {
    
    func testSHA256ToHex() {
        XCTAssertEqual(
            "JYGK Udsf6ITR^%$#UTY6GI7UGdsf gdsfgSDKHkjb768stb&(&T* &".sha256().hexString(),
            "71e80ab896673f757d3e378d9191d8432346d961cb59e224de31977bc23def76"
        )
    }
    
    func testSHA256ToBase64() {
        XCTAssertEqual(
            "JYGK Udsf6ITR^%$#UTY6GI7UGdsf gdsfgSDKHkjb768stb&(&T* &".sha256().base64EncodedString(),
            "cegKuJZnP3V9PjeNkZHYQyNG2WHLWeIk3jGXe8I973Y="
        )
    }
}

extension StringTests {
    
    func testIsNilOrEmpty() {
        var test: String?
        
        XCTAssert(test.isNilOrEmpty)
        
        test = ""
        XCTAssert(test.isNilOrEmpty)
        
        test = "abc"
        XCTAssertFalse(test.isNilOrEmpty)
    }
}
