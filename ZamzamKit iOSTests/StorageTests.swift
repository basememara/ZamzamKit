//
//  FileServiceTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import XCTest
@testable import ZamzamKit

class StorageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Clear all user data
        NSUserDefaults.standardUserDefaults()
            .removePersistentDomainForName("xctest")
    }
    
    func testSaveNSUserDefaults() {
        let key = "StorageServiceTests.testSaveNSUserDefaults"
        let expectedValue = "\(NSDate().timeIntervalSinceReferenceDate)"
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        NSUserDefaults.setUserValue(key, newValue: expectedValue)
        
        XCTAssertEqual(NSUserDefaults.standardUserDefaults().stringForKey(key), expectedValue,
            "NSUserDefaults for \(key) should be \(expectedValue)")
    }
    
    func testRestoreNSUserDefaults() {
        let key = "StorageServiceTests.testRestoreNSUserDefaults"
        let expectedValue = "\(NSDate().timeIntervalSinceReferenceDate)"
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        NSUserDefaults.setUserValue(key, newValue: expectedValue)
        
        let storedValue = NSUserDefaults.getUserValue(key)
        
        XCTAssertEqual("\(storedValue!)", expectedValue,
            "NSUserDefaults for \(key) should be \(expectedValue)")
    }
    
    func testDefaultAndRestoreNSUserDefaults() {
        let key = "StorageServiceTests.testDefaultAndRestoreNSUserDefaults"
        let expectedValue = "\(NSDate().timeIntervalSinceReferenceDate)"
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        NSUserDefaults.getUserValue(key, defaultValue: expectedValue)
        
        XCTAssertEqual(NSUserDefaults.standardUserDefaults().stringForKey(key), expectedValue,
            "NSUserDefaults for \(key) should be \(expectedValue)")
    }
    
    func testSaveNSUserDefaultsForDomain() {
        let key = "StorageServiceTests.testSaveNSUserDefaultsForDomain"
        let expectedValue = "\(NSDate().timeIntervalSinceReferenceDate)"
        
        NSUserDefaults.setUserValue(key, "xctest", newValue: expectedValue)
        
        XCTAssertEqual(NSUserDefaults(suiteName: "xctest")?.stringForKey(key), expectedValue,
            "NSUserDefaults for \(key) should be \(expectedValue)")
    }
    
    func testRestoreNSUserDefaultsForDomain() {
        let key = "StorageServiceTests.testRestoreNSUserDefaultsForDomain"
        let expectedValue = "\(NSDate().timeIntervalSinceReferenceDate)"
        
        NSUserDefaults.setUserValue(key, "xctest", newValue: expectedValue)
        let storedValue = NSUserDefaults.getUserValue(key, "xctest")
        
        XCTAssertEqual("\(storedValue!)", expectedValue,
            "NSUserDefaults for \(key) should be \(expectedValue)")
    }
    
    func testDefaultAndRestoreNSUserDefaultsForDomain() {
        let key = "StorageServiceTests.testDefaultAndRestoreNSUserDefaultsForDomain"
        let expectedValue = "\(NSDate().timeIntervalSinceReferenceDate)"
        
        NSUserDefaults.getUserValue(key, "xctest", defaultValue: expectedValue)
        
        XCTAssertEqual(NSUserDefaults(suiteName: "xctest")?.stringForKey(key), expectedValue,
            "NSUserDefaults for \(key) should be \(expectedValue)")
    }
}
