//
//  CollectionType.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/16/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension CollectionType {
    
    public func toArray() -> [Self.Generator.Element] {
        return self.map { $0 }
    }
    
}