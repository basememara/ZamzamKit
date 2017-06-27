//
//  NSBundleTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/4/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import XCTest
@testable import ZamzamKit

class BundleTests: XCTestCase {
    
    func testValuesFromText() {
        let values = Bundle.string(file: "Test.txt", bundle: Bundle(for: type(of: self)))
        
        XCTAssert(values == "This is a test. Abc 123.\n")
    }
    
    func testValuesFromPlist() {
        let values = Bundle.contents(plist: "Settings.plist", bundle: Bundle(for: type(of: self)))
        
        XCTAssert(values["MyString1"] as? String == "My string value 1.")
        XCTAssert(values["MyNumber1"] as? Int == 123)
        XCTAssert(values["MyBool1"] as? Bool == false)
        XCTAssert(values["MyDate1"] as? Date == Date(
            fromString: "2016/03/03 9:50",
            timeZone: TimeZone(identifier: "America/Toronto")
        )!)
    }
    
    func testArrayFromPlist() {
        let values = Bundle.contents(plist: "Settings.plist", bundle: Bundle(for: type(of: self)))
        let array = values["MyArray1"] as! [AnyObject]
        let expected: [Any] = [
            "My string for array value." as Any,
            999 as Any,
            true as Any
        ]
        
        XCTAssert(array[0] as! String == expected[0] as! String)
        XCTAssert(array[1] as! Int == expected[1] as! Int)
        XCTAssert(array[2] as! Bool == expected[2] as! Bool)
    }
    
    func testDictFromPlist() {
        let values = Bundle.contents(plist: "Settings.plist", bundle: Bundle(for: type(of: self)))
        let dict = values["MyDictionary1"] as! [String: Any]
        let expected: [String: Any] = [
            "id": 7 as Any,
            "title": "Garden" as Any,
            "active": true as Any
        ]
        
        XCTAssert(dict["id"] as! Int == expected["id"] as! Int)
        XCTAssert(dict["title"] as! String == expected["title"] as! String)
        XCTAssert(dict["active"] as! Bool == expected["active"] as! Bool)
    }

}
