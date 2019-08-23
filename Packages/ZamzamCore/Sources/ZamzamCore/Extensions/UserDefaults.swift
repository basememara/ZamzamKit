//
//  NSUserDefaults.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/18/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation

extension UserDefaults {
    // Slim version of: https://github.com/radex/SwiftyUserDefaults
    
    /// Gets and sets the value from User Defaults that corresponds to the given key.
    public subscript<T>(key: String.Key<T?>) -> T? {
        get { return object(forKey: key.name) as? T }
        
        set {
            guard let value = newValue else { return remove(key) }
            set(value, forKey: key.name)
        }
    }
    
    /// Removes the single User Defaults item specified by the key.
    ///
    /// - Parameter key: The key that is used to delete the user defaults item.
    public func remove<T>(_ key: String.Key<T?>) {
        removeObject(forKey: key.name)
    }
}

public extension UserDefaults {
    
    /// Removes all keys and values from User Defaults.
    /// - Note: This method only removes keys on the receiver `UserDefaults` object.
    ///         System-defined keys will still be present afterwards.
    func removeAll() {
        dictionaryRepresentation().forEach {
            removeObject(forKey: $0.key)
        }
    }
}
