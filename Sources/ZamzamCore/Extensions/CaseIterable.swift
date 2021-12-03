//
//  CaseIterable.swift
//  ZamzamCoreTests
//
//  Created by Basem Emara on 2021-03-26.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

public extension CaseIterable where Self: Equatable, AllCases: BidirectionalCollection {
    /// Returns the case immediately before the given case.
    func previous() -> Self? {
        // https://newbedev.com/how-to-get-next-case-of-enum-i-e-write-a-circulating-method-in-swift-4-2
        let array = Self.allCases
        guard let currentIndex = array.firstIndex(of: self) else { return nil }
        return array[safe: array.index(before: currentIndex)]
    }

    /// Returns the case immediately after the given case.
    func next() -> Self? {
        let array = Self.allCases
        guard let currentIndex = array.firstIndex(of: self) else { return nil }
        return array[safe: array.index(after: currentIndex)]
    }
}

// MARK: Decoding

/// A protocol that uses the last case iterable case there is no matching decodable value.
///
/// The `status` value in the JSON string below is not a valid `Status` case. Instead of allowing the decoding
/// process to fail, this protocol has an initializer extension that will fallback to the last case of the enum as default.
///
///     struct Example: Decodable {
///         let status: Status
///     }
///
///     enum Status: String, CaseIterableDefaultsLastDecodable {
///         case abc
///         case xyz
///         case unknown
///     }
///
///     let json = [{"status": "abc"}, {"status": "zzz"}].data(using: .utf8)
///     let object = try JSONDecoder().decode([Example].self, from: json)
///     print(object[0].status) // .abc
///     print(object[1].status) // .unknown
public protocol CaseIterableDefaultsLastDecodable: Decodable, CaseIterable, RawRepresentable
    where RawValue: Decodable, AllCases: BidirectionalCollection {}

public extension CaseIterableDefaultsLastDecodable {
    init(from decoder: Decoder) throws {
        // https://stackoverflow.com/a/49697266
        self = try Self(
            rawValue: decoder.singleValueContainer().decode()
        ) ?? Self.allCases.last!
        // swiftlint:disable:previous force_unwrapping
    }
}
