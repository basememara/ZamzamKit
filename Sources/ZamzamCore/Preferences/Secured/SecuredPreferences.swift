//
//  SecuredPreferences.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

/// A thin wrapper to manage Keychain, or other services that conform to `SecuredPreferencesService`.
///
///     let keychain = SecuredPreferences(
///         service: SecuredPreferencesKeychainService()
///     )
///
///     keychain.set("kjn989hi", forKey: .token)
///     keychain.get(.token) // "kjn989hi"
///
///     // Define strongly-typed keys
///     extension SecuredPreferencesAPI.Key {
///         static let token = SecuredPreferencesAPI.Key("token")
///     }
///
public struct SecuredPreferences {
    private let service: SecuredPreferencesService
    
    public init(service: SecuredPreferencesService) {
        self.service = service
    }
}

public extension SecuredPreferences {
    
    /// Retrieves the value from keychain that corresponds to the given key.
    ///
    /// Accessing the underlying Keychain storage is an expensive operation.
    /// Use a background thread when possible, then store within memory for future retrievals.
    ///
    /// - Parameter key: The key that is used to read the user defaults item.
    func get(_ key: SecuredPreferencesAPI.Key) -> String? {
        service.get(key)
    }
}

public extension SecuredPreferences {
    
    /// Stores the value in the keychain item under the given key.
    ///
    /// - Parameters:
    ///   - value: Value to be written to the keychain.
    ///   - key: Key under which the value is stored in the keychain.
    @discardableResult
    func set(_ value: String?, forKey key: SecuredPreferencesAPI.Key) -> Bool {
        service.set(value, forKey: key)
    }
}

public extension SecuredPreferences {
    
    /// Deletes the single keychain item specified by the key.
    ///
    /// - Parameter key: The key that is used to delete the keychain item.
    /// - Returns: True if the item was successfully deleted.
    @discardableResult
    func remove(_ key: SecuredPreferencesAPI.Key) -> Bool {
        service.remove(key)
    }
}
