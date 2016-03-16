//
//  Array.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/16/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Array {
    
    public func any() -> Bool {
        return self.count > 0
    }
    
    public func take(count: Int) -> [Element] {
        var to: [Element] = []
        var i = 0
        while i < self.count && i < count {
            to.append(self[i++])
        }
        return to
    }
    
    public func drop(count: Int) -> [Element] {
        var to: [Element] = []
        var i = count
        while i < self.count {
            to.append(self[i++])
        }
        return to
    }
    
    public func get(index: Int) -> Element? {
        return self.indices.contains(index)
            ? self[index] : nil
    }

}