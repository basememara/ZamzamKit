//
//  KeychainTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class KeychainTests: XCTestCase {
    private lazy var keychain = KeychainManager(
        service: KeychainTestService()
    )
}

extension KeychainTests {
    func testString() {
        // Given
        let value1 = "abc"
        let value2 = "xyz"

        // When
        keychain.set(value1, forKey: .testString1)
        keychain.set(value2, forKey: .testString2)

        // Then
        XCTAssertEqual(keychain.get(.testString1), value1)
        XCTAssertEqual(keychain.get(.testString2), value2)
    }
}

extension KeychainTests {
    func testRemove() {
        // Given
        let value1 = "abc"
        let value2 = "xyz"

        // When
        keychain.set(value1, forKey: .testString1)
        keychain.set(value2, forKey: .testString2)
        keychain.remove(.testString1)
        keychain.remove(.testString2)

        // Then
        XCTAssertNil(keychain.get(.testString1))
        XCTAssertNil(keychain.get(.testString2))
    }
}

private extension KeychainAPI.Key {
    static let testString1 = KeychainAPI.Key("testString1")
    static let testString2 = KeychainAPI.Key("testString2")
}

// MARK: - Helpers

// Unit test mocked since Keychain needs application host, see app for Keychain testing
// https://github.com/onmyway133/blog/issues/92
// https://forums.swift.org/t/host-application-for-spm-tests/24363
private class KeychainTestService: KeychainService {
    var values = [String: String?]()

    func get(_ key: KeychainAPI.Key) -> String? {
        values[key.name] ?? nil
    }

    func set(_ value: String?, forKey key: KeychainAPI.Key) -> Bool {
        values[key.name] = value
        return true
    }

    func remove(_ key: KeychainAPI.Key) -> Bool {
        values.removeValue(forKey: key.name)
        return true
    }
}
