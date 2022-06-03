//
//  Data.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSData

public extension Data {
    /// String by encoding Data using UTF8 encoding.
    var string: String? { string(encoding: .utf8) }

    /// String by encoding Data using the given encoding (if applicable).
    ///
    /// - Parameter encoding: encoding.
    /// - Returns: String by encoding Data using the given encoding (if applicable).
    func string(encoding: String.Encoding) -> String? {
        String(data: self, encoding: encoding)
    }
}

// MARK: - Encoding

public extension Data {
    /// Returns a URL safe Base-64 encoded string.
    func base64URLEncodedString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }

    /// Returns a hex string representation of the data.
    func hexString() -> String {
        // https://stackoverflow.com/a/55523487/235334
        reduce(into: "", { $0 += String(format: "%02x", $1) })
    }
}

// MARK: - Codable

public extension Data {
    /// Returns a value of the type you specify, decoded from a data object.
    func decode<T: Decodable>(decoder: JSONDecoder = JSONDecoder()) throws -> T {
        try decoder.decode(T.self, from: self)
    }
}

public extension Encodable {
    /// Returns the encoded data of the type you specify.
    func encode(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        try encoder.encode(self)
    }
}
