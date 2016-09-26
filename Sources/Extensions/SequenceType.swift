//
//  SequenceType.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/20/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Sequence {

    /// Converts collection of objects to JSON string
    var jsonString: String? {
        guard let data = self as? [[String: AnyObject]],
            let stringData = try? JSONSerialization.data(withJSONObject: data, options: [])
                else { return nil }
        
        return NSString(data: stringData, encoding: String.Encoding.utf8.rawValue) as? String
    }
    
    /**
     Returns the first that satisfies the predicate includeElement, or nil. Similar to `filter` but stops when one element is found.
     Thanks to [bigonotetaking](https://bigonotetaking.wordpress.com/2015/08/22/using-higher-order-methods-everywhere/)
     
     - parameter predicate: Predicate that the Element must satisfy.
     
     - returns: First element that satisfies the predicate, or nil.
     */
    public func first(_ predicate: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for x in self where predicate(x) { return x }
        return nil
    }
    
    /**
     Returns the last that satisfies the predicate includeElement, or nil. Similar to `filter` but stops when last element is found.
     Thanks to [bigonotetaking](https://bigonotetaking.wordpress.com/2015/08/22/using-higher-order-methods-everywhere/)
     
     - parameter predicate: Predicate that the Element must satisfy.
     
     - returns: Last element that satisfies the predicate, or nil.
     */
    public func last(_ pred: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for x in reversed() where pred(x) { return x }
        return nil
    }
    
    /**
     Returns true or false if the predicate returns all elements
     
     - parameter predicate: Predicate that all elements must satisfy
     
     - returns: Does the sequence contain all elements that satisfy the predicate
     */
    public func all(_ predicate: (Iterator.Element) -> Bool) -> Bool {
        return !contains { !predicate($0) }
    }
}
