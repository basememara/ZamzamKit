//
//  Dictionary.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/18/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Dictionary where Key == String, Value: Any {
    
    /// Converts dictionary of objects to JSON string
    var jsonString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self) else { return nil }
        return String(bytes: jsonData, encoding: .utf8)
    }
}
