//
//  NSBundleTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/4/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit
import XCTest
@testable import ZamzamKit

class BundleTests: XCTestCase {
    
    func testValuesFromPlist() {
        let values = Bundle.contentsOfFile("Settings.plist", bundle: Bundle(for: type(of: self)))
        
        XCTAssert(values["MyString1"] as? String == "My string value 1.")
        XCTAssert(values["MyNumber1"] as? Int == 123)
        XCTAssert(values["MyBool1"] as? Bool == false)
        
        // Calculate date and account for machine time zone
        // 2016-03-03 14:50:00 UTC
        let expectedDate = Date(timeIntervalSince1970:
            TimeInterval(1457002200 - Int(NSTimeZone.local.secondsFromGMT())))
        
        XCTAssert(values["MyDate1"] as? Date == expectedDate)
    }
    
    func testArrayFromPlist() {
        let values = Bundle.contentsOfFile("Settings.plist", bundle: Bundle(for: type(of: self)))
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
        let values = Bundle.contentsOfFile("Settings.plist", bundle: Bundle(for: type(of: self)))
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
    
    func testValuesFromBundle() {
        let values = Bundle.contentsOfFile(bundle: Bundle(for: type(of: self)))
        
        XCTAssert(values["SomeString1"] as? String == "My string value 1.")
        XCTAssert(values["SomeNumber1"] as? Int == 123)
        XCTAssert(values["SomeBool1"] as? Bool == false)
        
        // Calculate date and account for machine time zone
        // 2016-03-03 14:50:00 UTC
        let expectedDate = Date(timeIntervalSince1970:
            TimeInterval(1457002200 - Int(NSTimeZone.local.secondsFromGMT())))
        
        XCTAssert(values["SomeDate1"] as? Date == expectedDate)
    }
    
    func testArrayFromBundle() {
        let values = Bundle.contentsOfFile(bundle: Bundle(for: type(of: self)))
        let array = values["SomeArray1"] as! [AnyObject]
        let expected: [Any] = [
            "My string for array value." as Any,
            999 as Any,
            true as Any
        ]
        
        XCTAssert(array[0] as! String == expected[0] as! String)
        XCTAssert(array[1] as! Int == expected[1] as! Int)
        XCTAssert(array[2] as! Bool == expected[2] as! Bool)
    }
    
    func testDictFromBundle() {
        let values = Bundle.contentsOfFile(bundle: Bundle(for: type(of: self)))
        let dict = values["SomeDictionary1"] as! [String: Any]
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
