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
    /// Accesses the value for the key, first storing `initialValue` under it when the dictionary has none.
    ///
    ///     var counts = ["abc": 123]
    ///
    ///     counts["abc", initial: 999] // 123
    ///     counts["lmn", initial: 555] // 555
    ///     counts["lmn"] // 555
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
    /// Returns the dictionary as JSON data, or `nil` when JSON can't hold it, as with a `Date` value or a key that isn't a string.
    func jsonData(options: JSONSerialization.WritingOptions = []) -> Data? {
        JSONSerialization.isValidJSONObject(self)
            ? try? JSONSerialization.data(withJSONObject: self, options: options)
            : nil
    }

    /// Returns the dictionary as a JSON string, or `nil` when JSON can't hold it, as with a `Date` value or a key that isn't a string.
    func jsonString(options: JSONSerialization.WritingOptions = []) -> String? {
        jsonData(options: options)?.string
    }
}
