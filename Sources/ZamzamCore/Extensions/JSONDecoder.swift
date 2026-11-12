//
//  JSONDecoder.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-11-18.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSJSONSerialization

public extension JSONDecoder {
    /// Returns a value of the type you specify, decoded from a JSON string.
    ///
    /// - Throws: `DecodingError.dataCorrupted` when the string can't be written in `encoding`, or the error from decoding.
    func decode<T: Decodable>(_ type: T.Type, from string: String, using encoding: String.Encoding = .utf8) throws -> T {
        guard let data = string.data(using: encoding) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not encode data from string."))
        }

        return try decode(type, from: data)
    }
}
