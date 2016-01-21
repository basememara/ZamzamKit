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

class StorageServiceTests: XCTestCase {
    
    var manager: ZamzamManager!
    
    override func setUp() {
        super.setUp()
        
        manager = ZamzamManager()
        
        // Clear all user data
        NSUserDefaults.standardUserDefaults()
            .removePersistentDomainForName("xctest")
    }
    
    func testSaveNSUserDefaults() {
        let key = "StorageServiceTests.testSaveNSUserDefaults"
        let expectedValue = "\(NSDate().timeIntervalSinceReferenceDate)"
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        manager.storageService.setUserValue(key, newValue: expectedValue)
        
        XCTAssertEqual(NSUserDefaults.standardUserDefaults().stringForKey(key), expectedValue,
            "NSUserDefaults for \(key) should be \(expectedValue)")
    }
    
    func testRestoreNSUserDefaults() {
        let key = "StorageServiceTests.testRestoreNSUserDefaults"
        let expectedValue = "\(NSDate().timeIntervalSinceReferenceDate)"
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        manager.storageService.setUserValue(key, newValue: expectedValue)
        
        let storedValue = manager.storageService.getUserValue(key)
        
        XCTAssertEqual("\(storedValue!)", expectedValue,
            "NSUserDefaults for \(key) should be \(expectedValue)")
    }
    
    func testDefaultAndRestoreNSUserDefaults() {
        let key = "StorageServiceTests.testDefaultAndRestoreNSUserDefaults"
        let expectedValue = "\(NSDate().timeIntervalSinceReferenceDate)"
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        manager.storageService.getUserValue(key, defaultValue: expectedValue)
        
        XCTAssertEqual(NSUserDefaults.standardUserDefaults().stringForKey(key), expectedValue,
            "NSUserDefaults for \(key) should be \(expectedValue)")
    }
    
    func testSaveNSUserDefaultsForDomain() {
        let key = "StorageServiceTests.testSaveNSUserDefaultsForDomain"
        let expectedValue = "\(NSDate().timeIntervalSinceReferenceDate)"
        
        manager.storageService.setUserValue(key, "xctest", newValue: expectedValue)
        
        XCTAssertEqual(NSUserDefaults(suiteName: "xctest")?.stringForKey(key), expectedValue,
            "NSUserDefaults for \(key) should be \(expectedValue)")
    }
    
    func testRestoreNSUserDefaultsForDomain() {
        let key = "StorageServiceTests.testRestoreNSUserDefaultsForDomain"
        let expectedValue = "\(NSDate().timeIntervalSinceReferenceDate)"
        
        manager.storageService.setUserValue(key, "xctest", newValue: expectedValue)
        let storedValue = manager.storageService.getUserValue(key, "xctest")
        
        XCTAssertEqual("\(storedValue!)", expectedValue,
            "NSUserDefaults for \(key) should be \(expectedValue)")
    }
    
    func testDefaultAndRestoreNSUserDefaultsForDomain() {
        let key = "StorageServiceTests.testDefaultAndRestoreNSUserDefaultsForDomain"
        let expectedValue = "\(NSDate().timeIntervalSinceReferenceDate)"
        
        manager.storageService.getUserValue(key, "xctest", defaultValue: expectedValue)
        
        XCTAssertEqual(NSUserDefaults(suiteName: "xctest")?.stringForKey(key), expectedValue,
            "NSUserDefaults for \(key) should be \(expectedValue)")
    }
}
