//
//  NSUserDefaults.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/18/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension UserDefaults {
    
    /// Gets and sets the value from user defaults that corresponds to the given key.
    subscript<T>(key: DefaultsKey<T?>) -> T? {
        get { return object(forKey: key.name) as? T }
        
        set {
            guard let value = newValue else { return remove(key) }
            set(value, forKey: key.name)
        }
    }
    
    /// Removes the single user defaults item specified by the key.
    ///
    /// - Parameter key: The key that is used to delete the user defaults item.
    func remove<T>(_ key: DefaultsKey<T?>) {
        removeObject(forKey: key.name)
    }
    
    /// Removes all keys and values from user defaults.
    /// - Note: This method only removes keys on the receiver `UserDefaults` object.
    ///         System-defined keys will still be present afterwards.
    func removeAll() {
        dictionaryRepresentation().forEach {
            removeObject(forKey: $0.key)
        }
    }
}

/// User defaults keys for strong-typed access.
/// Taken from: https://github.com/radex/SwiftyUserDefaults
open class DefaultsKeys {
    fileprivate init() {}
}

open class DefaultsKey<ValueType>: DefaultsKeys {
    public let name: String
    
    public init(_ key: String) {
        self.name = key
        super.init()
    }
}
