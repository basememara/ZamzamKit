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

class NSBundleTests: XCTestCase {
    
    func testValuesFromPlist() {
        let values = NSBundle.contentsOfFile("Settings.plist", bundle: NSBundle(forClass: self.dynamicType))
        
        XCTAssert(values["MyString1"] as? String == "My string value 1.")
        XCTAssert(values["MyNumber1"] as? Int == 123)
        XCTAssert(values["MyBool1"] as? Bool == false)
        
        // Calculate date and account for machine time zone
        // 2016-03-03 14:50:00 UTC
        let expectedDate = NSDate(timeIntervalSince1970:
            NSTimeInterval(1457002200 - Int(NSTimeZone.localTimeZone().secondsFromGMT)))
        
        XCTAssert(values["MyDate1"] as? NSDate == expectedDate)
    }
    
    func testArrayFromPlist() {
        let values = NSBundle.contentsOfFile("Settings.plist", bundle: NSBundle(forClass: self.dynamicType))
        let array = values["MyArray1"] as! [AnyObject]
        let expected: [AnyObject] = [
            "My string for array value.",
            999,
            true
        ]
        
        XCTAssert(array[0] as! String == expected[0] as! String)
        XCTAssert(array[1] as! Int == expected[1] as! Int)
        XCTAssert(array[2] as! Bool == expected[2] as! Bool)
    }
    
    func testDictFromPlist() {
        let values = NSBundle.contentsOfFile("Settings.plist", bundle: NSBundle(forClass: self.dynamicType))
        let dict = values["MyDictionary1"] as! [String: AnyObject]
        let expected: [String: AnyObject] = [
            "id": 7,
            "title": "Garden",
            "active": true
        ]
        
        XCTAssert(dict["id"] as! Int == expected["id"] as! Int)
        XCTAssert(dict["title"] as! String == expected["title"] as! String)
        XCTAssert(dict["active"] as! Bool == expected["active"] as! Bool)
    }
    
    func testValuesFromBundle() {
        let values = NSBundle.contentsOfFile(bundle: NSBundle(forClass: self.dynamicType))
        
        XCTAssert(values["SomeString1"] as? String == "My string value 1.")
        XCTAssert(values["SomeNumber1"] as? Int == 123)
        XCTAssert(values["SomeBool1"] as? Bool == false)
        
        // Calculate date and account for machine time zone
        // 2016-03-03 14:50:00 UTC
        let expectedDate = NSDate(timeIntervalSince1970:
            NSTimeInterval(1457002200 - Int(NSTimeZone.localTimeZone().secondsFromGMT)))
        
        XCTAssert(values["SomeDate1"] as? NSDate == expectedDate)
    }
    
    func testArrayFromBundle() {
        let values = NSBundle.contentsOfFile(bundle: NSBundle(forClass: self.dynamicType))
        let array = values["SomeArray1"] as! [AnyObject]
        let expected: [AnyObject] = [
            "My string for array value.",
            999,
            true
        ]
        
        XCTAssert(array[0] as! String == expected[0] as! String)
        XCTAssert(array[1] as! Int == expected[1] as! Int)
        XCTAssert(array[2] as! Bool == expected[2] as! Bool)
    }
    
    func testDictFromBundle() {
        let values = NSBundle.contentsOfFile(bundle: NSBundle(forClass: self.dynamicType))
        let dict = values["SomeDictionary1"] as! [String: AnyObject]
        let expected: [String: AnyObject] = [
            "id": 7,
            "title": "Garden",
            "active": true
        ]
        
        XCTAssert(dict["id"] as! Int == expected["id"] as! Int)
        XCTAssert(dict["title"] as! String == expected["title"] as! String)
        XCTAssert(dict["active"] as! Bool == expected["active"] as! Bool)
    }

}