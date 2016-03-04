//
//  SequenceType.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/20/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension SequenceType {
    
    /**
     Returns the first that satisfies the predicate includeElement, or nil. Similar to `filter` but stops when one element is found. Thanks to [bigonotetaking](https://bigonotetaking.wordpress.com/2015/08/22/using-higher-order-methods-everywhere/)
     
     - parameter includeElement: Predicate that the Element must satisfy.
     
     - returns: First element that satisfies the predicate, or nil.
     */
    func first(@noescape includeElement: Generator.Element -> Bool) -> Generator.Element? {
        for x in self where includeElement(x) { return x }
        return nil
    }
    
    /**
     Returns true or false if the predicate includeElement
     
     - parameter includeElement: Predicate that the Element must satisfy
     
     - returns: Does element exists that satisfies the predicate
     */
    func any(@noescape includeElement: Generator.Element -> Bool) -> Bool {
        for x in self where includeElement(x) { return true }
        return false
    }
}