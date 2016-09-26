//
//  Array.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/16/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Array {
    
    /**
     Take a specified amount of elements.

     - parameter count: Number of elements to retrieve.

     - returns: Elements that specify the count number.
     */
    public func take(_ count: Int) -> [Element] {
        var to: [Element] = []
        var i = 0
        while i < self.count && i < count {
            to.append(self[i])
            i += 1
        }
        return to
    }

    /**
     Drop a specified amount of elements.

     - parameter count: Number of elements to drop.

     - returns: Elements that are left over.
     */
    public func drop(_ count: Int) -> [Element] {
        var to: [Element] = []
        var i = count
        while i < self.count {
            to.append(self[i])
            i += 1
        }
        return to
    }
    
    /**
     Optional element by indice.

     - parameter index: Indice of the array element.

     - returns: An optional element.
     */
    public func get(_ index: Int) -> Element? {
        return self.indices.contains(index)
            ? self[index] : nil
    }
    
    public func closestMatch(_ index: Int, predicate: (Element) -> Bool) -> (Int, Element)? {
        if predicate(self[index]) {
            return (index, self[index])
        }
        
        var delta = 1
        
        while(true) {
            guard index + delta < count || index - delta >= 0 else {
                return nil
            }
            
            if index + delta < count && predicate(self[index + delta]) {
                return (index + delta, self[index + delta])
            }
            
            if index - delta >= 0 && predicate(self[index - delta]) {
                return (index - delta, self[index - delta])
            }
            
            delta = delta + 1
        }
    }
    
    /**
     Remove array items in a thread-safe manner.

     - parameter handler: Handler with array item that was popped.
     */
    public mutating func removeEach(_ handler: @escaping (Element) -> Void) -> Void {
        self.enumerated().reversed().forEach { item in
            handler(self.remove(at: item.index))
        }
    }

}
