//
//  SecuredPreferencesAPI.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2020-03-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

// MARK: - Respository

/// A thin wrapper to manage Keychain, or other storages that conform to `SecuredPreferencesService`.
///
///     let keychain: SecuredPreferencesType = SecuredPreferences(
///         service: SecuredPreferencesKeychainService()
///     )
///
///     keychain.set("kjn989hi", forKey: .token)
///
///     keychain.get(.token) {
///         print($0) // "kjn989hi"
///     }
///
///     // Define strongly-typed keys
///     extension SecuredPreferencesAPI.Key {
///         static let token = SecuredPreferencesAPI.Key("token")
///     }
public protocol SecuredPreferencesType {
    
    /// Retrieves the value from keychain that corresponds to the given key.
    ///
    /// - Parameter key: The key that is used to read the user defaults item.
    func get(_ key: SecuredPreferencesAPI.Key, completion: @escaping (String?) -> Void)
    
    /// Stores the value in the keychain item under the given key.
    ///
    /// - Parameters:
    ///   - value: Value to be written to the keychain.
    ///   - key: Key under which the value is stored in the keychain.
    @discardableResult
    func set(_ value: String?, forKey key: SecuredPreferencesAPI.Key) -> Bool
    
    /// Deletes the single keychain item specified by the key.
    ///
    /// - Parameter key: The key that is used to delete the keychain item.
    /// - Returns: True if the item was successfully deleted.
    @discardableResult
    func remove(_ key: SecuredPreferencesAPI.Key) -> Bool
}

// MARK: - Service

public protocol SecuredPreferencesService {
    func get(_ key: SecuredPreferencesAPI.Key, completion: @escaping (String?) -> Void)
    func set(_ value: String?, forKey key: SecuredPreferencesAPI.Key) -> Bool
    func remove(_ key: SecuredPreferencesAPI.Key) -> Bool
}

// MARK: Namespace

public enum SecuredPreferencesAPI {
    
    /// Security key for compile-safe access.
    ///
    ///     extension SecuredPreferencesAPI.Key {
    ///         static let token = SecuredPreferencesAPI.Key("token")
    ///     }
    public struct Key {
        public let name: String
        
        public init(_ key: String) {
            self.name = key
        }
    }
}
