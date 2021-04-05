//
//  CodingStrategy.swift
//  ZamzamCoreTests
//
//  Created by Basem Emara on 2021-03-26.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSDateFormatter
import Foundation.NSJSONSerialization

public extension JSONDecoder {
    /// Configured JSON decoder for type.
    ///
    /// - Parameter type: The type to infer the `JSONDecoder` to use.
    /// - Returns: The decoder used to deserialize the model.
    static func make<T: Decodable>(for type: T.Type) -> JSONDecoder {
        let decoder = JSONDecoder()

        switch type {
        case is SnakeCaseKeyDecodable.Type:
            decoder.keyDecodingStrategy = .convertFromSnakeCase
        default:
            break
        }

        switch type {
        case is ISO8601DateDecodable.Type:
            decoder.dateDecodingStrategy = .formatted(
                DateFormatter(iso8601Format: DateFormatter.dateFormat8601)
            )
        case is ZuluDateDecodable.Type:
            decoder.dateDecodingStrategy = .formatted(
                DateFormatter(iso8601Format: DateFormatter.dateFormatZ)
            )
        default:
            break
        }

        return decoder
    }
}

public extension JSONEncoder {
    /// Configured JSON encoder for type.
    ///
    /// - Parameter object: The object to infer the `JSONEncoder` to use.
    /// - Returns: The encoder used to serialize the model.
    static func make<T: Encodable>(for object: T) -> JSONEncoder {
        let encoder = JSONEncoder()

        switch object {
        case is SnakeCaseKeyEncodable:
            encoder.keyEncodingStrategy = .convertToSnakeCase
        default:
            break
        }

        switch object {
        case is ISO8601DateEncodable:
            encoder.dateEncodingStrategy = .formatted(
                DateFormatter(iso8601Format: DateFormatter.dateFormat8601)
            )
        case is ZuluDateEncodable:
            encoder.dateEncodingStrategy = .formatted(
                DateFormatter(iso8601Format: DateFormatter.dateFormatZ)
            )
        default:
            break
        }

        return encoder
    }
}

// MARK: - SnakeCase

/// A phantom type that indicates `snake_case` key decoding and encoding strategy for services to infer.
///
/// Decoders and encoders cannot be mixed in nested scenarios. Only the parent decoder and encoder is used for all children types regardless of the key strategies assigned to them.
public protocol SnakeCaseKeyCodable: SnakeCaseKeyEncodable, SnakeCaseKeyDecodable {}

/// A phantom type that indicates `snake_case` key decoding strategy for services to infer.
///
///     let decoder = JSONDecoder.make(for: MyType.self)
///     let object = try decoder.decode(MyType.self, from: data)
///
/// Decoders cannot be mixed in nested scenarios. Only the parent decoder is used for all children types regardless of the key strategies assigned to them.
public protocol SnakeCaseKeyDecodable: Decodable {}

/// A phantom type that indicates `snake_case` key encoding strategy for services to infer.
///
///     let encoder = JSONEncoder.make(for: object)
///     let data = try encoder.encode(object)
///
/// Encoders cannot be mixed in nested scenarios. Only the parent encoder is used for all children types regardless of the key strategies assigned to them.
public protocol SnakeCaseKeyEncodable: Encodable {}

// MARK: - ISO8601Date

/// A phantom type that indicates `yyyy-MM-dd'T'HH:mm:ssZ` date format decoding and encoding strategy for services to infer, .i.e "2021-02-25T05:34:47+00:00".
///
/// Decoders and encoders cannot be mixed in nested scenarios. Only the parent decoder and encoder is used for all children types regardless of the date strategies assigned to them.
public protocol ISO8601DateCodable: ISO8601DateEncodable, ISO8601DateDecodable {}

/// A phantom type that indicates `yyyy-MM-dd'T'HH:mm:ssZ` date format decoding strategy for services to infer, .i.e "2021-02-25T05:34:47+00:00".
///
///     let decoder = JSONDecoder.make(for: MyType.self)
///     let object = try decoder.decode(MyType.self, from: data)
///
/// Decoders cannot be mixed in nested scenarios. Only the parent decoder is used for all children types regardless of the date strategies assigned to them.
public protocol ISO8601DateDecodable: Decodable {}

/// A phantom type that indicates `yyyy-MM-dd'T'HH:mm:ssZ` date format encoding strategy for services to infer, .i.e "2021-02-25T05:34:47+00:00".
///
///     let encoder = JSONEncoder.make(for: object)
///     let data = try encoder.encode(object)
///
/// Encoders cannot be mixed in nested scenarios. Only the parent encoder is used for all children types regardless of the date strategies assigned to them.
public protocol ISO8601DateEncodable: Encodable {}

// MARK: - ZuluDate

/// A phantom type that indicates `yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ` date format decoding and encoding strategy for services to infer, .i.e "2021-02-03T20:19:55.317Z".
///
/// Decoders and encoders cannot be mixed in nested scenarios. Only the parent decoder and encoder is used for all children types regardless of the date strategies assigned to them.
public protocol ZuluDateCodable: ZuluDateEncodable, ZuluDateDecodable {}

/// A phantom type that indicates `yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ` date format decoding strategy for services to infer, .i.e "2021-02-03T20:19:55.317Z".
///
///     let decoder = JSONDecoder.make(for: MyType.self)
///     let object = try decoder.decode(MyType.self, from: data)
///
/// Decoders cannot be mixed in nested scenarios. Only the parent decoder is used for all children types regardless of the date strategies assigned to them.
public protocol ZuluDateDecodable: Decodable {}

/// A phantom type that indicates `yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ` date format encoding strategy for services to infer, .i.e "2021-02-03T20:19:55.317Z".
///
///     let encoder = JSONEncoder.make(for: object)
///     let data = try encoder.encode(object)
///
/// Encoders cannot be mixed in nested scenarios. Only the parent encoder is used for all children types regardless of the date strategies assigned to them.
public protocol ZuluDateEncodable: Encodable {}

// MARK: - CaseIterable

/// A protocol that uses the last case iterable case there is no matching decodable value.
public protocol CaseIterableDefaultsLastDecodable: Decodable, CaseIterable, RawRepresentable
where RawValue: Decodable, AllCases: BidirectionalCollection {}

public extension CaseIterableDefaultsLastDecodable {
    init(from decoder: Decoder) throws {
        // https://stackoverflow.com/a/49697266
        self = try Self(
            rawValue: decoder.singleValueContainer().decode(RawValue.self)
        ) ?? Self.allCases.last!
        // swiftlint:disable:previous force_unwrapping
    }
}
