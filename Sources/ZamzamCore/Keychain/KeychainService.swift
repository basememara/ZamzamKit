//
//  KeychainService.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSData

/// A store for small secrets, such as tokens, kept under typed keys.
public protocol KeychainService {
    /// Returns the text stored under the key, or `nil` when there is none or it can't be read.
    func get(_ key: KeychainAPI.Key) -> String?
    /// Stores text under the key, replacing any value there. A `nil` value removes the item. Returns whether it succeeded.
    @discardableResult
    func set(_ value: String?, forKey key: KeychainAPI.Key) -> Bool

    /// Returns the data stored under the key, or `nil` when there is none or it can't be read.
    func get(_ key: KeychainAPI.Key) -> Data?
    /// Stores data under the key, replacing any value there. A `nil` value removes the item. Returns whether it succeeded.
    @discardableResult
    func set(_ value: Data?, forKey key: KeychainAPI.Key) -> Bool

    /// Removes the item under the key. Returns whether it succeeded.
    @discardableResult
    func remove(_ key: KeychainAPI.Key) -> Bool
}

// MARK: - Namespace

/// The namespace for the keychain's types.
public enum KeychainAPI {
    /// Security key for compile-safe access.
    ///
    ///     extension KeychainAPI.Key {
    ///         static let token = KeychainAPI.Key("token")
    ///     }
    ///
    public struct Key: ExpressibleByStringLiteral, Sendable {
        /// The name the item is stored under.
        public let name: String

        /// Creates a key with the given name.
        public init(_ key: String) {
            self.name = key
        }

        /// Creates a key from a string literal.
        public init(stringLiteral value: StaticString) {
            self.init("\(value)")
        }
    }
}
