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

extension CollectionType where Generator.Element == (String, AnyObject) {
    
    /// Converts collection of objects to JSON string
    var jsonString: String? {
        guard let data = self as? NSDictionary,
            let stringData = try? NSJSONSerialization.dataWithJSONObject(data, options: [])
            else { return nil }
        
        return NSString(data: stringData, encoding: NSUTF8StringEncoding) as? String
    }
}