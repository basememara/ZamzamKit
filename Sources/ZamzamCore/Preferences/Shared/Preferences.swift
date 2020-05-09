//
//  Preferences.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-05-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

/// A thin wrapper to manage `UserDefaults`, or other services that conform to `PreferencesService`.
///
///     let preferences = Preferences(
///         service: PreferencesDefaultsService(
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
public struct Preferences {
    private let service: PreferencesService
    
    public init(service: PreferencesService) {
        self.service = service
    }
}

public extension Preferences {
    
    /// Retrieves the value from user defaults that corresponds to the given key.
    ///
    /// - Parameter key: The key that is used to read the user defaults item.
    func get<T>(_ key: PreferencesAPI.Key<T?>) -> T? {
        service.get(key)
    }
}

public extension Preferences {
    
    /// Stores the value in the user defaults item under the given key.
    ///
    /// - Parameters:
    ///   - value: Value to be written to the user defaults.
    ///   - key: Key under which the value is stored in the user defaults.
    func set<T>(_ value: T?, forKey key: PreferencesAPI.Key<T?>) {
        service.set(value, forKey: key)
    }
}

public extension Preferences {
    
    /// Deletes the single user defaults item specified by the key.
    ///
    /// - Parameter key: The key that is used to delete the user default item.
    /// - Returns: True if the item was successfully deleted.
    func remove<T>(_ key: PreferencesAPI.Key<T?>) {
        service.remove(key)
    }
}
