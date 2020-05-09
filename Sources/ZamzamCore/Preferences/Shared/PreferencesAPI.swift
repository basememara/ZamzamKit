//
//  PreferencesAPI.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-05-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

// MARK: - Service

public protocol PreferencesService {
    func get<T>(_ key: PreferencesAPI.Key<T?>) -> T?
    func set<T>(_ value: T?, forKey key: PreferencesAPI.Key<T?>)
    func remove<T>(_ key: PreferencesAPI.Key<T?>)
}

// MARK: Namespace

public enum PreferencesAPI {
    
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
