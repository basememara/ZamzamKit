//
//  Data.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public extension Data {
    
    ///String by encoding Data using UTF8 encoding.
    var string: String? {
        return string(encoding: .utf8)
    }
    
    ///String by encoding Data using the given encoding (if applicable).
    ///
    /// - Parameter encoding: encoding.
    /// - Returns: String by encoding Data using the given encoding (if applicable).
    func string(encoding: String.Encoding) -> String? {
        // https://github.com/SwifterSwift
        return String(data: self, encoding: encoding)
    }
}
