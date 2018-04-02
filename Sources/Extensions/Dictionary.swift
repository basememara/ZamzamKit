//
//  Dictionary.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/18/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Dictionary where Value: Any {
    
    /**
     Convert tuple to dictionary.
     
     - returns: Dictionary from tuple.
     */
    init<S: Sequence>(_ seq: S) where S.Iterator.Element == (Key, Value) {
        self.init()
        for (k, v) in seq { self[k] = v }
    }
    
    /**
     Remove all values equal to null.
     
     - returns: Keys removed due to being null.
     */
    @discardableResult
    mutating func removeAllNulls() -> [Key] {
        let keysWithNull: [Key] = self.compactMap {
            guard $0.value is NSNull else { return nil }
            return $0.key
        }
        
        guard !keysWithNull.isEmpty else { return [] }
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

/// Combine dictionaries.
func + <K,V> (left: Dictionary<K,V>, right: Dictionary<K,V>?) -> Dictionary<K,V> {
    // http://stackoverflow.com/a/34527546/235334
    guard let right = right else { return left }
    return left.reduce(right) {
        var new = $0 as [K:V]
        new.updateValue($1.1, forKey: $1.0)
        return new
    }
}

/// Append dictionary.
func += <K,V> (left: inout Dictionary<K,V>, right: Dictionary<K,V>?) {
    // http://stackoverflow.com/a/34527546/235334
    guard let right = right else { return }
    right.forEach { left.updateValue($0.value, forKey: $0.key) }
}
