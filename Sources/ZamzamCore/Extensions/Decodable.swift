//
//  Decodable.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation.NSDate

/// A type-erased `Decodable` value.
///
/// The `AnyDecodable` type forwards decoding responsibilities
/// to an underlying value, hiding its specific underlying type.
///
/// You can decode mixed-type values in dictionaries
/// and other collections that require `Decodable` conformance
/// by declaring their contained type to be `AnyDecodable`:
///
///     let json = """
///     {
///         "boolean": true,
///         "integer": 1,
///         "double": 3.14159265358979323846,
///         "string": "string",
///         "date": "2018-12-05T15:28:25+00:00",
///         "array": [1, 2, 3],
///         "nested": {
///             "a": "alpha",
///             "b": "bravo",
///             "c": "charlie"
///         }
///     }
///     """.data(using: .utf8)!
///
///     let decoder = JSONDecoder()
///     let dictionary = try? decoder.decode([String: AnyDecodable].self, from: json)
public struct AnyDecodable: Decodable {
    // https://github.com/Flight-School/AnyCodable
    /// The decoded value: a `Bool`, `Int`, `UInt`, `Double`, `Date` or `String`, an array or dictionary of these, or `()`
    /// for null.
    public let value: Any

    /// Wraps a value, or `()` when it is `nil`.
    public init<T>(_ value: T?) {
        self.value = value ?? ()
    }
}

private protocol _AnyDecodable {
    var value: Any { get }
    init<T>(_ value: T?)
}

extension AnyDecodable: _AnyDecodable {}

extension _AnyDecodable {
    /// Decodes the first type that fits, tried in the order `Bool`, `Int`, `UInt`, `Double`, `Date`, `String`, array,
    /// dictionary. A number is never read as a date, since `Double` comes first.
    ///
    /// - Throws: `DecodingError.dataCorrupted` when none fits.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.init(())
        } else if let bool = try? container.decode(Bool.self) {
            self.init(bool)
        } else if let int = try? container.decode(Int.self) {
            self.init(int)
        } else if let uint = try? container.decode(UInt.self) {
            self.init(uint)
        } else if let double = try? container.decode(Double.self) {
            self.init(double)
        } else if let date = try? container.decode(Date.self) {
            self.init(date)
        } else if let string = try? container.decode(String.self) {
            self.init(string)
        } else if let array = try? container.decode([AnyDecodable].self) {
            self.init(array.map(\.value))
        } else if let dictionary = try? container.decode([String: AnyDecodable].self) {
            self.init(dictionary.mapValues { $0.value })
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
        }
    }
}
