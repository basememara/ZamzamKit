//
//  File.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2017-11-27.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class StringKeysTests: XCTestCase {

    private let defaults = UserDefaults(suiteName: "StringKeysTests")!
    
    override func setUp() {
        super.setUp()
        defaults.removeAll()
    }
}

extension StringKeysTests {
    
    func testString() {
        defaults[.testString1] = "abc"
        defaults[.testString2] = "xyz"
        
        XCTAssertEqual(defaults[.testString1], "abc")
        XCTAssertEqual(defaults[.testString2], "xyz")
    }
    
    func testBoolean() {
        defaults[.testBool1] = true
        defaults[.testBool2] = false
        
        XCTAssertEqual(defaults[.testBool1], true)
        XCTAssertEqual(defaults[.testBool2], false)
    }
    
    func testInteger() {
        defaults[.testInt1] = 123
        defaults[.testInt2] = 987
        
        XCTAssertEqual(defaults[.testInt1], 123)
        XCTAssertEqual(defaults[.testInt2], 987)
    }
    
    func testFloat() {
        defaults[.testFloat1] = 1.1
        defaults[.testFloat2] = 9.9
        
        XCTAssertEqual(defaults[.testFloat1], 1.1)
        XCTAssertEqual(defaults[.testFloat2], 9.9)
    }
    
    func testDouble() {
        defaults[.testDouble1] = 2.123456789
        defaults[.testDouble2] = 9.876543219
        
        XCTAssertEqual(defaults[.testDouble1], 2.123456789)
        XCTAssertEqual(defaults[.testDouble2], 9.876543219)
    }
    
    func testDate() {
        let value1 = Date()
        let value2 = Date(timeIntervalSinceNow: 12345678)
        
        defaults[.testDate1] = value1
        defaults[.testDate2] = value2
        
        XCTAssertEqual(defaults[.testDate1], value1)
        XCTAssertEqual(defaults[.testDate2], value2)
    }
    
    func testArray() {
        let value1 = ["abc", "def", "ghi", "lmn"]
        let value2 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        defaults[.testArray1] = value1
        defaults[.testArray2] = value2
        
        XCTAssertEqual(defaults[.testArray1]!, value1)
        XCTAssertEqual(defaults[.testArray2]!, value2)
    }
    
    func testDictionary() {
        let value1 = ["abc": "xyz", "def": "tuv", "ghi": "qrs"]
        let value2 = ["abc": 123, "def": 456, "ghi": 789]
        
        defaults[.testDictionary1] = value1
        defaults[.testDictionary2] = value2
        
        XCTAssertEqual(defaults[.testDictionary1]!, value1)
        XCTAssertEqual(defaults[.testDictionary2]!, value2)
    }
}

private extension String.Keys {
    static let testString1 = String.Key<String?>("testString1")
    static let testString2 = String.Key<String?>("testString2")
    static let testBool1 = String.Key<Bool?>("testBool1")
    static let testBool2 = String.Key<Bool?>("testBool2")
    static let testInt1 = String.Key<Int?>("testInt1")
    static let testInt2 = String.Key<Int?>("testInt2")
    static let testFloat1 = String.Key<Float?>("testFloat1")
    static let testFloat2 = String.Key<Float?>("testFloat2")
    static let testDouble1 = String.Key<Double?>("testDouble1")
    static let testDouble2 = String.Key<Double?>("testDouble2")
    static let testDate1 = String.Key<Date?>("testDate1")
    static let testDate2 = String.Key<Date?>("testDate2")
    static let testArray1 = String.Key<[String]?>("testArray1")
    static let testArray2 = String.Key<[Int]?>("testArray2")
    static let testDictionary1 = String.Key<[String: String]?>("testDictionary1")
    static let testDictionary2 = String.Key<[String: Int]?>("testDictionary2")
}
