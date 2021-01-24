//
//  KeychainService.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

public protocol KeychainService {
    func get(_ key: KeychainAPI.Key) -> String?
    func set(_ value: String?, forKey key: KeychainAPI.Key) -> Bool
    func remove(_ key: KeychainAPI.Key) -> Bool
}

// MARK: Namespace

public enum KeychainAPI {
    
    /// Security key for compile-safe access.
    ///
    ///     extension KeychainAPI.Key {
    ///         static let token = KeychainAPI.Key("token")
    ///     }
    public struct Key {
        public let name: String
        
        public init(_ key: String) {
            self.name = key
        }
    }
}
