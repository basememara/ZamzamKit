//
//  LocaleTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/19/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import XCTest
@testable import ZamzamKit

class LocaleTests: XCTestCase {
    
    func testPosix() {
        let test: Locale = .posix
        XCTAssertEqual(test.identifier, "en_US_POSIX")
    }
	
	func testIntConversion() {
        let expectedValue = 123456789
        let localizedString: String = .localizedStringWithFormat("%d", expectedValue)
        XCTAssertNil(Int(localizedString)) //Could not convert
        XCTAssertEqual(localizedString.intValue, expectedValue)
	}
	
	func testDoubleConversion() {
        let expectedValue: Double = 123456789.987
        let localizedString: String = .localizedStringWithFormat("%.3f", expectedValue)
        XCTAssertNil(Double(localizedString)) //Could not convert
        XCTAssertEqual(localizedString.doubleValue, expectedValue)
	}
	
	func testFloatConversion() {
        let expectedValue: Float = 123456789.987
        let localizedString: String = .localizedStringWithFormat("%.3f", expectedValue)
        XCTAssertNil(Float(localizedString)) //Could not convert
        XCTAssertEqual(localizedString.floatValue, expectedValue)
	}
	
	func testBoolConversion() {
        XCTAssertNil(Bool("١")) //Could not convert
        XCTAssertEqual("١".boolValue, true)
	}
}
