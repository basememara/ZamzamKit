//
//  SecuredPreferencesTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class SecuredPreferencesTests: XCTestCase {
    
    private lazy var keychain: SecuredPreferencesType = SecuredPreferences(
        service: SecuredPreferencesTestService()
    )
}

extension SecuredPreferencesTests {
    
    func testString() {
        // Given
        let promise1 = expectation(description: "\(#function)1")
        let promise2 = expectation(description: "\(#function)2")
        let value1 = "abc"
        let value2 = "xyz"
        
        // When
        keychain.set(value1, forKey: .testString1)
        keychain.set(value2, forKey: .testString2)
        
        // Then
        keychain.get(.testString1) {
            XCTAssertEqual($0, value1)
            promise1.fulfill()
        }
        
        keychain.get(.testString2) {
            XCTAssertEqual($0, value2)
            promise2.fulfill()
        }
        
        wait(for: [promise1, promise2], timeout: 10)
    }
}

extension SecuredPreferencesTests {
    
    func testRemove() {
        // Given
        let promise1 = expectation(description: "\(#function)1")
        let promise2 = expectation(description: "\(#function)2")
        let value1 = "abc"
        let value2 = "xyz"
        
        // When
        keychain.set(value1, forKey: .testString1)
        keychain.set(value2, forKey: .testString2)
        keychain.remove(.testString1)
        keychain.remove(.testString2)
        
        // Then
        keychain.get(.testString1) {
            XCTAssertNil($0)
            promise1.fulfill()
        }
        
        keychain.get(.testString2) {
            XCTAssertNil($0)
            promise2.fulfill()
        }
        
        wait(for: [promise1, promise2], timeout: 10)
    }
}

private extension SecuredPreferencesAPI.Key {
    static let testString1 = SecuredPreferencesAPI.Key("testString1")
    static let testString2 = SecuredPreferencesAPI.Key("testString2")
}

// MARK: - Helpers

// Unit test mocked since Keychain needs application host, see app for Keychain testing
// https://github.com/onmyway133/blog/issues/92
// https://forums.swift.org/t/host-application-for-spm-tests/24363
private class SecuredPreferencesTestService: SecuredPreferencesService {
    var values = [String: String?]()
    
    func get(_ key: SecuredPreferencesAPI.Key, completion: @escaping (String?) -> Void) {
        guard let value = values[key.name] else {
            completion(nil)
            return
        }
        
        completion(value)
    }
    
    func set(_ value: String?, forKey key: SecuredPreferencesAPI.Key) -> Bool {
        values[key.name] = value
        return true
    }
    
    func remove(_ key: SecuredPreferencesAPI.Key) -> Bool {
        values.removeValue(forKey: key.name)
        return true
    }
}
