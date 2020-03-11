//
//  Data.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSData

public extension Data {
    
    ///String by encoding Data using UTF8 encoding.
    var string: String? { string(encoding: .utf8) }
    
    ///String by encoding Data using the given encoding (if applicable).
    ///
    /// - Parameter encoding: encoding.
    /// - Returns: String by encoding Data using the given encoding (if applicable).
    func string(encoding: String.Encoding) -> String? {
        String(data: self, encoding: encoding)
    }
}

public extension Data {
    
    /// Returns a hex string representation of the data.
    var hexString: String {
        // https://stackoverflow.com/a/55523487/235334
        reduce("", { $0 + String(format: "%02x", $1) })
    }
}
