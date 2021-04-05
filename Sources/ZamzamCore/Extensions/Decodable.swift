//
//  Decodable.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2018-06-12.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation.NSDate

/// Skips failed elements during decoding instead exiting collection completely; lossy array decoding.
public struct FailableDecodableArray<Element: Decodable>: Decodable {
    // https://github.com/phynet/Lossy-array-decode-swift4
    private struct DummyCodable: Codable {}

    private struct FailableDecodable<Base: Decodable>: Decodable {
        let base: Base?

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            do {
                self.base = try container.decode(Base.self)
            } catch {
                self.base = nil
                print("🤍 \(timestamp: Date()) ERROR Failed to decode \(Base.self): \(error)")
            }
        }
    }

    public private(set) var elements: [Element]

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: [Element] = []

        if let count = container.count {
            elements.reserveCapacity(count)
        }

        while !container.isAtEnd {
            guard let element = try container.decode(FailableDecodable<Element>.self).base else {
                _ = try? container.decode(DummyCodable.self)
                continue
            }

            elements.append(element)
        }

        self.elements = elements
    }
}

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
    public let value: Any

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
            self.init(array.map { $0.value })
        } else if let dictionary = try? container.decode([String: AnyDecodable].self) {
            self.init(dictionary.mapValues { $0.value })
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
        }
    }
}
