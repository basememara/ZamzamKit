//
//  DecodingStrategy.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-02-23.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSJSONSerialization

private extension JSONDecoder {
    static let dateFormat8601 = "yyyy-MM-dd'T'HH:mm:s.SSSSZZZZZ"
    static let dateFormatZ = "yyyy-MM-dd'T'HH:mm:s.SSSZ"
}

public extension JSONDecoder {
    /// Configured JSON decoder for type.
    ///
    /// - Parameter type: The type to infer the `JSONDecoder` to use.
    /// - Returns: The decoder used to deserialize the model.
    static func make<T: Decodable>(for type: T.Type) -> JSONDecoder {
        let decoder = JSONDecoder()

        // Date encoding strategy
        switch type {
        case is ISO8601DateDecodable.Type:
            decoder.dateDecodingStrategy = .formatted(
                DateFormatter(iso8601Format: Self.dateFormat8601)
            )
        case is ZuluDateDecodable.Type:
            decoder.dateDecodingStrategy = .formatted(
                DateFormatter(iso8601Format: Self.dateFormatZ)
            )
        default:
            break
        }

        // Key encoding strategy
        switch type {
        case is SnakeCaseKeyDecodable.Type:
            decoder.keyDecodingStrategy = .convertFromSnakeCase
        default:
            break
        }

        return decoder
    }
}

// MARK: - Strategies

/// A phantom type that indicates `2021-02-25T05:34:47.4747+00:00` date format decoding strategy for services to infer.
///
///     let decoder = JSONDecoder.make(for: MyType.self)
///     let object = try decoder.decode(MyType.self, from: data)
///
/// See `APIService` for example usage.
public protocol ISO8601DateDecodable: Decodable {}

/// A phantom type that indicates `2021-02-03T20:19:55.317Z` date format decoding strategy for services to infer.
///
///     let decoder = JSONDecoder.make(for: MyType.self)
///     let object = try decoder.decode(MyType.self, from: data)
///
/// See `APIService` for example usage.
public protocol ZuluDateDecodable: Decodable {}

/// A phantom type that indicates `snake_case` key decoding strategy for services to infer.
///
///     let decoder = JSONDecoder.make(for: MyType.self)
///     let object = try decoder.decode(MyType.self, from: data)
///
/// See `APIService` for example usage.
public protocol SnakeCaseKeyDecodable: Decodable {}
