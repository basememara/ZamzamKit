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
    public init<S: Sequence>(_ seq: S) where S.Iterator.Element == (Key, Value) {
        self.init()
        for (k, v) in seq { self[k] = v }
    }
    
    /**
     Remove all values equal to null.
     
     - returns: Keys removed due to being null.
     */
    public mutating func removeAllNulls() -> [Key] {
        let keysWithNull = self
            .filter { $0.value is NSNull }
            .map { $0.key }
        
        for key in keysWithNull {
            removeValue(forKey: key)
        }
        
        return Array(keysWithNull)
    }
    
}

// http://stackoverflow.com/a/34527546/235334
func + <K,V> (left: Dictionary<K,V>, right: Dictionary<K,V>?) -> Dictionary<K,V> {
    guard let right = right else { return left }
    return left.reduce(right) {
        var new = $0 as [K:V]
        new.updateValue($1.1, forKey: $1.0)
        return new
    }
}

// http://stackoverflow.com/a/34527546/235334
func += <K,V> (left: inout Dictionary<K,V>, right: Dictionary<K,V>?) {
    guard let right = right else { return }
    right.forEach { key, value in
        left.updateValue(value, forKey: key)
    }
}
