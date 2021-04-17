//
//  CaseIterable.swift
//  ZamzamCoreTests
//
//  Created by Basem Emara on 2021-03-26.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

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
