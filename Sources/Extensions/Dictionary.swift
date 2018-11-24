//
//  Dictionary.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/18/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Dictionary where Value: Any {
    
    /// Remove all values equal to nil.
    ///
    ///     var value: [String: Any?] = [
    ///         "abc": 123,
    ///         "efd": "xyz",
    ///         "ghi": NSNull(),
    ///         "lmm": true,
    ///         "qrs": NSNull(),
    ///         "tuv": 987
    ///     ]
    ///
    ///     value.removeAllNils()
    ///
    ///     value.count -> 4
    ///     value.keys.contains("abc") -> true
    ///     value.keys.contains("ghi") -> false
    ///     value.keys.contains("qrs") -> false
    ///
    /// - Returns: Keys removed due to being null.
    @discardableResult
    mutating func removeAllNils() -> [Key] {
        let keysWithNull = filter { $0.value is NSNull }.map { $0.key }
        keysWithNull.forEach { removeValue(forKey: $0) }
        return keysWithNull
    }
}

public extension Dictionary where Value == Optional<Any> {
    
    /// Remove all values equal to nil.
    ///
    ///     var value: [String: Any?] = [
    ///         "abc": 123,
    ///         "efd": "xyz",
    ///         "ghi": nil,
    ///         "lmm": true,
    ///         "qrs": nil,
    ///         "tuv": 987
    ///     ]
    ///
    ///     value.removeAllNils()
    ///
    ///     value.count -> 4
    ///     value.keys.contains("abc") -> true
    ///     value.keys.contains("ghi") -> false
    ///     value.keys.contains("qrs") -> false
    ///
    /// - Returns: Keys removed due to being null.
    @discardableResult
    mutating func removeAllNils() -> [Key] {
        let keysWithNull = filter { $0.value == nil }.map { $0.key }
        keysWithNull.forEach { removeValue(forKey: $0) }
        return keysWithNull
    }
}

public extension Dictionary where Key == String, Value: Any {
    
    /// Converts dictionary of objects to JSON string
    var jsonString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self) else { return nil }
        return String(bytes: jsonData, encoding: .utf8)
    }
}
