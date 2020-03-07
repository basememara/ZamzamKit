//
//  PreferencesStoreInterfaces.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2019-05-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

/// Preferences request namespace
public enum PreferencesAPI {}

public protocol PreferencesStore {
    func get<T>(_ key: PreferencesAPI.Key<T?>) -> T?
    func set<T>(_ value: T?, forKey key: PreferencesAPI.Key<T?>)
    func remove<T>(_ key: PreferencesAPI.Key<T?>)
}

/// A thin wrapper to manage `UserDefaults`, or other storages that conform to `PreferencesStore`.
///
///     let preferences: PreferencesType = Preferences(
///         store: PreferencesDefaultsStore(
///             defaults: UserDefaults.standard
///         )
///     )
///
///     preferences.set(123, forKey: .abc)
///     preferences.get(.token) // 123
///
///     // Define strongly-typed keys
///     extension PreferencesAPI.Keys {
///         static let abc = PreferencesAPI.Key<String>("abc")
///     }
public protocol PreferencesType {
    
    /// Retrieves the value from user defaults that corresponds to the given key.
    ///
    /// - Parameter key: The key that is used to read the user defaults item.
    func get<T>(_ key: PreferencesAPI.Key<T?>) -> T?
    
    /// Stores the value in the user defaults item under the given key.
    ///
    /// - Parameters:
    ///   - value: Value to be written to the user defaults.
    ///   - key: Key under which the value is stored in the user defaults.
    func set<T>(_ value: T?, forKey key: PreferencesAPI.Key<T?>)
    
    /// Deletes the single user defaults item specified by the key.
    ///
    /// - Parameter key: The key that is used to delete the user default item.
    /// - Returns: True if the item was successfully deleted.
    func remove<T>(_ key: PreferencesAPI.Key<T?>)
}

// MARK: Requests / Responses

extension PreferencesAPI {
    
    /// Keys for strongly-typed access for generic types.
    open class Keys {
        fileprivate init() {}
    }
    
    /// Preferences key for strongly-typed access.
    ///
    ///     extension PreferencesAPI.Keys {
    ///         static let abc = PreferencesAPI.Key<String>("abc")
    ///     }
    open class Key<ValueType>: Keys {
        public let name: String
        
        public init(_ key: String) {
            self.name = key
            super.init()
        }
    }
}
