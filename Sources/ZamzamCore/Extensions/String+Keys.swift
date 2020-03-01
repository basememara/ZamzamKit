//
//  String+Keys.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

extension String {
    
    /// Keys for strongly-typed access for User Defaults, Keychain, or custom types.
    ///
    ///     // First define keys with associated types
    ///     extension String.Keys {
    ///         static let testString = String.Key<String?>("testString")
    ///         static let testInt = String.Key<Int?>("testInt")
    ///         static let testBool = String.Key<Bool?>("testBool")
    ///         static let testArray = String.Key<[Int]?>("testArray")
    ///     }
    ///
    ///     // Create method or subscript for generic types using the keys
    ///     extension UserDefaults {
    ///     
    ///         subscript<T>(key: String.Key<T?>) -> T? {
    ///             get { object(forKey: key.name) as? T }
    ///             set { set(value, forKey: key.name) }
    ///         }
    ///     }
    ///
    ///     // Then use strongly-typed values
    ///     let testString: String? = UserDefaults.standard[.testString]
    ///     let testInt: Int? = UserDefaults.standard[.testInt]
    ///     let testBool: Bool? = UserDefaults.standard[.testBool]
    ///     let testArray: [Int]? = UserDefaults.standard[.testArray]
    open class Keys {
        fileprivate init() {}
    }
    
    /// User Defaults key for strongly-typed access.
    open class Key<ValueType>: Keys {
        public let name: String
        
        public init(_ key: String) {
            self.name = key
            super.init()
        }
    }
}
