//
//  PreferencesTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2017-11-27.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class PreferencesTests: XCTestCase {
    
    private lazy var preferences = Preferences(
        service: PreferencesDefaultsService(
            defaults: UserDefaults(suiteName: "PreferencesTests")!
        )
    )
}

extension PreferencesTests {
    
    func testString() {
        preferences.set("abc", forKey: .testString1)
        preferences.set("xyz", forKey: .testString2)
        
        XCTAssertEqual(preferences.get(.testString1), "abc")
        XCTAssertEqual(preferences.get(.testString2), "xyz")
    }
    
    func testBoolean() {
        preferences.set(true, forKey: .testBool1)
        preferences.set(false, forKey: .testBool2)
        
        XCTAssertEqual(preferences.get(.testBool1), true)
        XCTAssertEqual(preferences.get(.testBool2), false)
    }
    
    func testInteger() {
        preferences.set(123, forKey: .testInt1)
        preferences.set(987, forKey: .testInt2)
        
        XCTAssertEqual(preferences.get(.testInt1), 123)
        XCTAssertEqual(preferences.get(.testInt2), 987)
    }
    
    func testFloat() {
        preferences.set(1.1, forKey: .testFloat1)
        preferences.set(9.9, forKey: .testFloat2)
        
        XCTAssertEqual(preferences.get(.testFloat1), 1.1)
        XCTAssertEqual(preferences.get(.testFloat2), 9.9)
    }
    
    func testDouble() {
        preferences.set(2.123456789, forKey: .testDouble1)
        preferences.set(9.876543219, forKey: .testDouble2)
        
        XCTAssertEqual(preferences.get(.testDouble1), 2.123456789)
        XCTAssertEqual(preferences.get(.testDouble2), 9.876543219)
    }
    
    func testDate() {
        let value1 = Date()
        let value2 = Date(timeIntervalSinceNow: 12345678)
        
        preferences.set(value1, forKey: .testDate1)
        preferences.set(value2, forKey: .testDate2)
        
        XCTAssertEqual(preferences.get(.testDate1), value1)
        XCTAssertEqual(preferences.get(.testDate2), value2)
    }
    
    func testArray() {
        let value1 = ["abc", "def", "ghi", "lmn"]
        let value2 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        preferences.set(value1, forKey: .testArray1)
        preferences.set(value2, forKey: .testArray2)
        
        XCTAssertEqual(preferences.get(.testArray1), value1)
        XCTAssertEqual(preferences.get(.testArray2), value2)
    }
    
    func testDictionary() {
        let value1 = ["abc": "xyz", "def": "tuv", "ghi": "qrs"]
        let value2 = ["abc": 123, "def": 456, "ghi": 789]
        
        preferences.set(value1, forKey: .testDictionary1)
        preferences.set(value2, forKey: .testDictionary2)
        
        XCTAssertEqual(preferences.get(.testDictionary1), value1)
        XCTAssertEqual(preferences.get(.testDictionary2), value2)
    }
}

private extension PreferencesAPI.Keys {
    static let testString1 = PreferencesAPI.Key<String?>("testString1")
    static let testString2 = PreferencesAPI.Key<String?>("testString2")
    static let testBool1 = PreferencesAPI.Key<Bool?>("testBool1")
    static let testBool2 = PreferencesAPI.Key<Bool?>("testBool2")
    static let testInt1 = PreferencesAPI.Key<Int?>("testInt1")
    static let testInt2 = PreferencesAPI.Key<Int?>("testInt2")
    static let testFloat1 = PreferencesAPI.Key<Float?>("testFloat1")
    static let testFloat2 = PreferencesAPI.Key<Float?>("testFloat2")
    static let testDouble1 = PreferencesAPI.Key<Double?>("testDouble1")
    static let testDouble2 = PreferencesAPI.Key<Double?>("testDouble2")
    static let testDate1 = PreferencesAPI.Key<Date?>("testDate1")
    static let testDate2 = PreferencesAPI.Key<Date?>("testDate2")
    static let testArray1 = PreferencesAPI.Key<[String]?>("testArray1")
    static let testArray2 = PreferencesAPI.Key<[Int]?>("testArray2")
    static let testDictionary1 = PreferencesAPI.Key<[String: String]?>("testDictionary1")
    static let testDictionary2 = PreferencesAPI.Key<[String: Int]?>("testDictionary2")
}
