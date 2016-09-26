//
//  CollectionType.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/16/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Collection {
    
    public func toArray() -> [Self.Iterator.Element] {
        return self.map { $0 }
    }
}

extension Collection where Iterator.Element == (String, AnyObject) {
    
    /// Converts collection of objects to JSON string
    var jsonString: String? {
        guard let data = self as? NSDictionary,
            let stringData = try? JSONSerialization.data(withJSONObject: data, options: [])
            else { return nil }
        
        return NSString(data: stringData, encoding: String.Encoding.utf8.rawValue) as? String
    }
}
