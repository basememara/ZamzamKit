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
    
    public func take(count: Int) -> ArraySlice<Element> {
        return self[0 ..< count]
    }

}