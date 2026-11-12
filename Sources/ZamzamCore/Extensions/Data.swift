//
//  Data.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSData

public extension Data {
    /// The data read as UTF-8 text, or `nil` when it isn't valid UTF-8.
    var string: String? { string(encoding: .utf8) }

    /// Returns the data read as text in the encoding, or `nil` when it isn't valid in that encoding.
    func string(encoding: String.Encoding) -> String? {
        String(data: self, encoding: encoding)
    }
}

// MARK: - Encoding

public extension Data {
    /// Returns the data as Base64 in the URL-safe alphabet (`-` and `_`), without padding.
    func base64URLEncodedString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }

    /// Returns the bytes as lowercase hexadecimal, two characters each.
    func hexString() -> String {
        // https://stackoverflow.com/a/55523487/235334
        reduce(into: "", { $0 += String(format: "%02x", $1) })
    }
}

// MARK: - Codable

public extension Data {
    /// Returns a value of the type you specify, decoded from the data as JSON.
    func decode<T: Decodable>(decoder: JSONDecoder = JSONDecoder()) throws -> T {
        try decoder.decode(T.self, from: self)
    }
}

public extension Encodable {
    /// Returns the value encoded as JSON data.
    func encode(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        try encoder.encode(self)
    }
}
