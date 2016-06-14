//
//  StringHelper.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import XCTest
@testable import ZamzamKit

class StringTests: XCTestCase {
    
    func testReplaceRegEx() {
        let value = "my car reg 1 - DD11 AAA  my car reg 2 - AA22 BBB"
        let pattern = "([A-HK-PRSVWY][A-HJ-PR-Y])\\s?([0][2-9]|[1-9][0-9])\\s?[A-HJ-PR-Z]{3}"
        
        let newValue = value.replaceRegEx(pattern, replaceValue: "XX")
        let expectedValue = "my car reg 1 - XX  my car reg 2 - XX"
        
        XCTAssertEqual(newValue, expectedValue,
            "String should be \(expectedValue)")
    }
    
    func testEmailRegEx() {
        let value = "contact@zamzam.io"
        let wrong = "zamzam"
        
        XCTAssertTrue(value.isEmail(), "Email \(value) should be valid.")
        XCTAssertFalse(wrong.isEmail(), "Email \(value) should not be valid.")
    }
    
    func testNumberRegEx() {
        let value = "123456789"
        let wrong = "zamzam"
        
        XCTAssertTrue(value.isNumber(), "Number \(value) should be valid.")
        XCTAssertFalse(wrong.isNumber(), "Number \(value) should not be valid.")
    }
    
    func testAlphaRegEx() {
        let value = "zamzam"
        let wrong = "zamzam123"
        
        XCTAssertTrue(value.isAlpha(), "Alpha \(value) should be valid.")
        XCTAssertFalse(wrong.isAlpha(), "Alpha \(value) should not be valid.")
    }
    
    func testAlphaNumbericRegEx() {
        let value = "zamzam123"
        let wrong = "zamzam!"
        
        XCTAssertTrue(value.isAlphaNumeric(), "Alphanumberic \(value) should be valid.")
        XCTAssertFalse(wrong.isAlphaNumeric(), "Alphanumberic \(value) should not be valid.")
    }
}
