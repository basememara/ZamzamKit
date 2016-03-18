//
//  Dictionary.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/18/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Dictionary where Value: AnyObject {
    
    /**
     Convert tuple to dictionary.
     
     - returns: Dictionary from tuple.
     */
    public init<S: SequenceType where S.Generator.Element == (Key, Value)>(_ seq: S) {
        self.init()
        for (k, v) in seq { self[k] = v }
    }
    
    /**
     Remove all values equal to null.
     
     - returns: Keys removed due to being null.
     */
    public mutating func removeAllNulls() -> [Key] {
        let keysWithNull = self.keys.filter { self[$0] is NSNull }
        
        for key in keysWithNull {
            removeValueForKey(key)
        }
        
        return Array(keysWithNull)
    }
    
}