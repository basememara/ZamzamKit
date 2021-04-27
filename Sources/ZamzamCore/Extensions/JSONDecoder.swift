//
//  JSONDecoder.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-11-18.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSJSONSerialization

public extension JSONDecoder {
    /// Creates a new, reusable JSON decoder with a specified date decoding strategy.
    /// - Parameter dateFormatter: The strategy that defers formatting settings to a supplied date formatter.
    convenience init(dateFormatter: DateFormatter) {
        self.init()
        self.dateDecodingStrategy = .formatted(dateFormatter)
    }
}

public extension JSONDecoder {
    /// Decodes an instance of the indicated type.
    ///
    /// - Parameters:
    ///   - type: The type to decode.
    ///   - string: The string representation of the JSON object.
    func decode<T: Decodable>(_ type: T.Type, from string: String, using encoding: String.Encoding = .utf8) throws -> T {
        guard let data = string.data(using: encoding) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Could not encode data from string."
                )
            )
        }

        return try decode(type, from: data)
    }
}

public extension KeyedDecodingContainerProtocol {
    // https://www.swiftbysundell.com/articles/type-inference-powered-serialization-in-swift/

    /// Decodes a value of the given type for the given key.
    /// - Parameter key: The key that the decoded value is associated with.
    func decode<T: Decodable>(forKey key: Key) throws -> T {
        try decode(T.self, forKey: key)
    }

    /// Decodes a value of the given type for the given key, if present.
    /// - Parameter key: The key that the decoded value is associated with.
    func decodeIfPresent<T: Decodable>(forKey key: Key) throws -> T? {
        try decodeIfPresent(T.self, forKey: key)
    }

    /// Decodes a value of the given type for the given key, if present.
    /// - Parameters:
    ///   - key: The key that the decoded value is associated with.
    ///   - defaultExpression: The default value if no key is present or the value is `Nil`.
    func decode<T: Decodable>(forKey key: Key, default defaultExpression: @autoclosure () -> T) throws -> T {
        try decodeIfPresent(T.self, forKey: key) ?? defaultExpression()
    }
}

public extension SingleValueDecodingContainer {
    /// Decodes a single value of the given type.
    func decode<T: Decodable>() throws -> T {
        try decode(T.self)
    }
}
