//
//  KeychainTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct KeychainTests {
    private let keychain: KeychainService = KeychainServiceTest()
}

extension KeychainTests {
    @Test
    func string() {
        // Given
        let value1 = "abc"
        let value2 = "xyz"

        // When
        keychain.set(value1, forKey: .testString1)
        keychain.set(value2, forKey: .testString2)

        // Then
        #expect(keychain.get(.testString1) == value1)
        #expect(keychain.get(.testString2) == value2)
    }
}

extension KeychainTests {
    @Test
    func data() throws {
        // Given
        let value1 = "abc"
        let value2 = "xyz"

        // When
        keychain.set(try value1.encode(), forKey: .testString1)
        keychain.set(try value2.encode(), forKey: .testString2)

        // Then
        let encoded1 = try value1.encode()
        let encoded2 = try value2.encode()

        #expect(keychain.get(.testString1) == encoded1)
        #expect(keychain.get(.testString2) == encoded2)
    }
}

extension KeychainTests {
    @Test
    func remove() {
        // Given
        let value1 = "abc"
        let value2 = "xyz"

        // When
        keychain.set(value1, forKey: .testString1)
        keychain.set(value2, forKey: .testString2)
        keychain.remove(.testString1)
        keychain.remove(.testString2)

        // Then
        #expect(keychain.get(.testString1) as String? == nil)
        #expect(keychain.get(.testString2) as String? == nil)
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
private class KeychainServiceTest: KeychainService {
    var values = [String: Any?]()

    func get(_ key: KeychainAPI.Key) -> String? {
        values[key.name] as? String ?? nil
    }

    func set(_ value: String?, forKey key: KeychainAPI.Key) -> Bool {
        values[key.name] = value
        return true
    }

    func get(_ key: KeychainAPI.Key) -> Data? {
        values[key.name] as? Data ?? nil
    }

    func set(_ value: Data?, forKey key: KeychainAPI.Key) -> Bool {
        values[key.name] = value
        return true
    }

    func remove(_ key: KeychainAPI.Key) -> Bool {
        values.removeValue(forKey: key.name)
        return true
    }
}
