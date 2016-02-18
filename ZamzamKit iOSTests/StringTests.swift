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
}
