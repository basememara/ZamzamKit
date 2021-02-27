//
//  Dictionary.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation.NSData
import Foundation.NSJSONSerialization

public extension Dictionary {
    /// Accesses the value with the given key. If the dictionary doesn’t contain the given key,
    /// assign the provided initial value as if the key and initial value existed in the dictionary.
    ///
    /// Use this subscript when you want either the value for a particular key or, when that key
    /// is not present in the dictionary, persist the initial value and return it.
    ///
    ///     var dictionary = [
    ///         "abc": 123,
    ///         "def": 456,
    ///         "xyz": 789
    ///     ]
    ///
    ///     let value = dictionary["abc", initial: 999] // Prints: 123
    ///     let value2 = dictionary["lmn", initial: 555] // Prints: 555
    ///     print(dictionary["lmn"]) // Prints: 555
    ///
    /// - Parameters:
    ///   - key: The key the look up in the dictionary.
    ///   - initialValue: The default value to use if key doesn’t exist in the dictionary.
    /// - Returns: The value associated with key in the dictionary; otherwise, initialValue after it has been written to the dictionary.
    subscript(key: Key, initial initialValue: @autoclosure () -> Value) -> Value {
        mutating get {
            guard let value = self[key] else {
                let value = initialValue()
                self[key] = value
                return value
            }

            return value
        }
    }
}

public extension Dictionary {
    /// Returns JSON data encoded in UTF-8.
    /// - Parameter options: Options for creating the JSON data.
    func jsonData(options: JSONSerialization.WritingOptions = []) -> Data? {
        JSONSerialization.isValidJSONObject(self)
            ? try? JSONSerialization.data(withJSONObject: self, options: options)
            : nil
    }

    /// Returns JSON string encoded in UTF-8.
    /// - Parameter options: Options for creating the JSON data.
    func jsonString(options: JSONSerialization.WritingOptions = []) -> String? {
        jsonData(options: options)?.string
    }
}
