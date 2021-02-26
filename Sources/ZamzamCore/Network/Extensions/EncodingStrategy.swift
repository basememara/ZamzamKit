//
//  EncodingStrategy.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-02-24.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSJSONSerialization

private extension JSONEncoder {
    static let dateFormat8601 = "yyyy-MM-dd'T'HH:mm:s.SSSSZZZZZ"
    static let dateFormatZ = "yyyy-MM-dd'T'HH:mm:s.SSSZ"
}

public extension JSONEncoder {
    /// Configured JSON encoder for type.
    ///
    /// - Parameter object: The object to infer the `JSONEncoder` to use.
    /// - Returns: The encoder used to serialize the model.
    static func make<T: Encodable>(for object: T) -> JSONEncoder {
        let encoder = JSONEncoder()

        // Date encoding strategy
        switch object {
        case is ISO8601DateEncodable:
            encoder.dateEncodingStrategy = .formatted(
                DateFormatter(iso8601Format: Self.dateFormat8601)
            )
        case is ZuluDateEncodable:
            encoder.dateEncodingStrategy = .formatted(
                DateFormatter(iso8601Format: Self.dateFormatZ)
            )
        default:
            break
        }

        // Key encoding strategy
        switch object {
        case is SnakeCaseKeyEncodable:
            encoder.keyEncodingStrategy = .convertToSnakeCase
        default:
            break
        }

        return encoder
    }
}

// MARK: - Strategies

/// A phantom type that indicates `2021-02-25T05:34:47.4747+00:00` date format encoding strategy for services to infer.
///
///     let encoder = JSONEncoder.make(for: object)
///     let data = try encoder.encode(object)
public protocol ISO8601DateEncodable: Encodable {}

/// A phantom type that indicates `2021-02-03T20:19:55.317Z` date format encoding strategy for services to infer.
///
///     let encoder = JSONEncoder.make(for: object)
///     let data = try encoder.encode(object)
public protocol ZuluDateEncodable: Encodable {}

/// A phantom type that indicates `snake_case` key encoding strategy for services to infer.
///
///     let encoder = JSONEncoder.make(for: object)
///     let data = try encoder.encode(object)
public protocol SnakeCaseKeyEncodable: Encodable {}
