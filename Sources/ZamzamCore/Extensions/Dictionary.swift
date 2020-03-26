//
//  Dictionary.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation.NSData
import Foundation.NSJSONSerialization

public extension Dictionary {
    
    /// Returns JSON data encoded in UTF-8.
    /// - Parameter options: Options for creating the JSON data.
    func jsonData(options: JSONSerialization.WritingOptions = []) -> Data? {
        JSONSerialization.isValidJSONObject(self)
            ? try? JSONSerialization.data(withJSONObject: self, options: options)
            : nil
    }
    
    /// Returns JSON string encoded in UTF-8.
    /// - Parameter options: Options for creating the JSON data.
    func jsonString(options: JSONSerialization.WritingOptions = []) -> String? {
        jsonData(options: options)?.string
    }
}
