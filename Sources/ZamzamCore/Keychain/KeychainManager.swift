//
//  SecuredPreferences.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSDate

/// A thin wrapper to manage Keychain, or other services that conform to `KeychainService`.
///
///     let keychain = KeychainManager(
///         service: KeychainExternalService()
///     )
///
///     keychain.set("kjn989hi", forKey: .token)
///     keychain.get(.token) // "kjn989hi"
///
///     // Define strongly-typed keys
///     extension KeychainAPI.Key {
///         static let token = KeychainAPI.Key("token")
///     }
///
public struct KeychainManager {
    private let service: KeychainService

    public init(service: KeychainService) {
        self.service = service
    }
}

public extension KeychainManager {
    /// Retrieves the value from keychain that corresponds to the given key.
    ///
    /// Accessing the underlying Keychain storage is an expensive operation.
    /// Use a background thread when possible, then store within memory for future retrievals.
    ///
    /// - Parameter key: The key that is used to read the keychain item.
    func get(_ key: KeychainAPI.Key) -> String? {
        service.get(key)
    }

    /// Stores the value in the keychain item under the given key.
    ///
    /// - Parameters:
    ///   - value: Value to be written to the keychain.
    ///   - key: Key under which the value is stored in the keychain.
    @discardableResult
    func set(_ value: String?, forKey key: KeychainAPI.Key) -> Bool {
        let result = service.set(value, forKey: key)
        Self.subject.send(key.name)
        return result
    }
}

public extension KeychainManager {
    /// Retrieves the value from keychain that corresponds to the given key.
    ///
    /// Accessing the underlying Keychain storage is an expensive operation.
    /// Use a background thread when possible, then store within memory for future retrievals.
    ///
    /// - Parameter key: The key that is used to read the keychain item.
    func get(_ key: KeychainAPI.Key) -> Bool? {
        service.get(key)
    }

    /// Stores the value in the keychain item under the given key.
    ///
    /// - Parameters:
    ///   - value: Value to be written to the keychain.
    ///   - key: Key under which the value is stored in the keychain.
    @discardableResult
    func set(_ value: Bool?, forKey key: KeychainAPI.Key) -> Bool {
        let result = service.set(value, forKey: key)
        Self.subject.send(key.name)
        return result
    }
}

// MARK: - Extensions

public extension KeychainManager {
    /// Retrieves the value from keychain that corresponds to the given key.
    ///
    /// Accessing the underlying Keychain storage is an expensive operation.
    /// Use a background thread when possible, then store within memory for future retrievals.
    ///
    /// - Parameter key: The key that is used to read the keychain item.
    func get(_ key: KeychainAPI.Key) -> Int? {
        guard let string: String = get(key) else { return nil }
        return Int(string)
    }

    /// Stores the value in the keychain item under the given key.
    ///
    /// - Parameters:
    ///   - value: Value to be written to the keychain.
    ///   - key: Key under which the value is stored in the keychain.
    @discardableResult
    func set(_ value: Int?, forKey key: KeychainAPI.Key) -> Bool {
        guard let value = value else { return remove(key) }
        return set("\(value)", forKey: key)
    }
}

public extension KeychainManager {
    /// Retrieves the value from keychain that corresponds to the given key.
    ///
    /// Accessing the underlying Keychain storage is an expensive operation.
    /// Use a background thread when possible, then store within memory for future retrievals.
    ///
    /// - Parameter key: The key that is used to read the keychain item.
    func get(_ key: KeychainAPI.Key) -> Double? {
        guard let string: String = get(key) else { return nil }
        return Double(string)
    }

    /// Stores the value in the keychain item under the given key.
    ///
    /// - Parameters:
    ///   - value: Value to be written to the keychain.
    ///   - key: Key under which the value is stored in the keychain.
    @discardableResult
    func set(_ value: Double?, forKey key: KeychainAPI.Key) -> Bool {
        guard let value = value else { return remove(key) }
        return set("\(value)", forKey: key)
    }
}

public extension KeychainManager {
    /// Retrieves the value from keychain that corresponds to the given key.
    ///
    /// Accessing the underlying Keychain storage is an expensive operation.
    /// Use a background thread when possible, then store within memory for future retrievals.
    ///
    /// - Parameter key: The key that is used to read the keychain item.
    func get(_ key: KeychainAPI.Key) -> Date? {
        guard let timestamp: Double = get(key) else { return nil }
        return Date(timeIntervalSince1970: timestamp)
    }

    /// Stores the value in the keychain item under the given key.
    ///
    /// - Parameters:
    ///   - value: Value to be written to the keychain.
    ///   - key: Key under which the value is stored in the keychain.
    @discardableResult
    func set(_ value: Date?, forKey key: KeychainAPI.Key) -> Bool {
        guard let value = value else { return remove(key) }
        return set(value.timeIntervalSince1970, forKey: key)
    }
}

// MARK: - Misc

public extension KeychainManager {
    /// Deletes the single keychain item specified by the key.
    ///
    /// - Parameter key: The key that is used to delete the keychain item.
    /// - Returns: True if the item was successfully deleted.
    @discardableResult
    func remove(_ key: KeychainAPI.Key) -> Bool {
        let result = service.remove(key)
        Self.subject.send(key.name)
        return result
    }
}

// MARK: - Observables

#if canImport(Combine)
import Combine

public extension KeychainManager {
    private static let subject = PassthroughSubject<String, Never>()

    /// Returns a publisher that emits events when broadcasting secured preference changes.
    func publisher() -> AnyPublisher<String, Never> {
        Self.subject.eraseToAnyPublisher()
    }
}
#endif
