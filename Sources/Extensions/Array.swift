//
//  Array.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/16/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Array {
    
    public func take(count: Int) -> [Element] {
        var to: [Element] = []
        var i = 0
        while i < self.count && i < count {
            i += 1
            to.append(self[i])
        }
        return to
    }
    
    public func drop(count: Int) -> [Element] {
        var to: [Element] = []
        var i = count
        while i < self.count {
            i += 1
            to.append(self[i])
        }
        return to
    }
    
    public func get(index: Int) -> Element? {
        return self.indices.contains(index)
            ? self[index] : nil
    }
    
    public func closestMatch(index: Int, predicate: (Element) -> Bool) -> (Int, Element)? {
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

}