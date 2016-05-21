//
//  SequenceType.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/20/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension SequenceType {

    /// Converts collection of objects to JSON string
    var jsonString: String? {
        guard let data = self as? [[String: AnyObject]],
            let stringData = try? NSJSONSerialization.dataWithJSONObject(data, options: [])
                else { return nil }
        
        return NSString(data: stringData, encoding: NSUTF8StringEncoding) as? String
    }
    
    /**
     Returns the first that satisfies the predicate includeElement, or nil. Similar to `filter` but stops when one element is found.
     Thanks to [bigonotetaking](https://bigonotetaking.wordpress.com/2015/08/22/using-higher-order-methods-everywhere/)
     
     - parameter predicate: Predicate that the Element must satisfy.
     
     - returns: First element that satisfies the predicate, or nil.
     */
    public func first(@noescape predicate: Generator.Element -> Bool) -> Generator.Element? {
        for x in self where predicate(x) { return x }
        return nil
    }
    
    /**
     Returns the last that satisfies the predicate includeElement, or nil. Similar to `filter` but stops when last element is found.
     Thanks to [bigonotetaking](https://bigonotetaking.wordpress.com/2015/08/22/using-higher-order-methods-everywhere/)
     
     - parameter predicate: Predicate that the Element must satisfy.
     
     - returns: Last element that satisfies the predicate, or nil.
     */
    public func last(@noescape pred: Generator.Element -> Bool) -> Generator.Element? {
        for x in reverse() where pred(x) { return x }
        return nil
    }
    
    /**
     Returns true or false if the predicate returns all elements
     
     - parameter predicate: Predicate that all elements must satisfy
     
     - returns: Does the sequence contain all elements that satisfy the predicate
     */
    public func all(@noescape predicate:(Generator.Element) -> Bool) -> Bool {
        return !contains { !predicate($0) }
    }
}