//
//  CollectionType.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/16/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Collection {
    
    /// Element at the given index if it exists.
    ///
    /// - Parameter index: index of element.
    subscript(safe index: Index) -> Element? {
        // http://www.vadimbulavin.com/handling-out-of-bounds-exception/
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Collection where Iterator.Element == (String, Any) {
    
    /// Converts collection of objects to JSON string
    var jsonString: String? {
		guard JSONSerialization.isValidJSONObject(self),
            let stringData = try? JSONSerialization.data(withJSONObject: self, options: []) else {
                return nil
        }
        
        return String(data: stringData, encoding: .utf8)
    }
}
