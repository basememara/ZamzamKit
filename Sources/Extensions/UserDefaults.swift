//
//  NSUserDefaults.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/18/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

extension UserDefaults {
    // Slim version of: https://github.com/radex/SwiftyUserDefaults
    
    /// User defaults keys for strongly-typed access.
    ///
    ///     // First define keys
    ///     extension UserDefaults.Keys {
    ///         static let testString = UserDefaults.Key<String?>("testString")
    ///         static let testInt = UserDefaults.Key<Int?>("testInt")
    ///         static let testBool = UserDefaults.Key<Bool?>("testBool")
    ///         static let testArray = UserDefaults.Key<[Int]?>("testArray")
    ///     }
    ///
    ///     // Then use strongly-typed values
    ///     let testString: String? = UserDefaults.standard[.testString]
    ///     let testInt: Int? = UserDefaults.standard[.testInt]
    ///     let testBool: Bool? = UserDefaults.standard[.testBool]
    ///     let testArray: [Int]? = UserDefaults.standard[.testArray]
    open class Keys {
        init() {} // TODO: Add `fileprivate` when deprecations removed
    }
    
    /// User defaults key for strongly-typed access.
    open class Key<ValueType>: Keys {
        public let name: String
        
        public init(_ key: String) {
            self.name = key
            super.init()
        }
    }
    
    /// Gets and sets the value from user defaults that corresponds to the given key.
    public subscript<T>(key: Key<T?>) -> T? {
        get { return object(forKey: key.name) as? T }
        
        set {
            guard let value = newValue else { return remove(key) }
            set(value, forKey: key.name)
        }
    }
    
    /// Removes the single user defaults item specified by the key.
    ///
    /// - Parameter key: The key that is used to delete the user defaults item.
    public func remove<T>(_ key: Key<T?>) {
        removeObject(forKey: key.name)
    }
}

public extension UserDefaults {
    
    /// Removes all keys and values from user defaults.
    /// - Note: This method only removes keys on the receiver `UserDefaults` object.
    ///         System-defined keys will still be present afterwards.
    func removeAll() {
        dictionaryRepresentation().forEach {
            removeObject(forKey: $0.key)
        }
    }
}
