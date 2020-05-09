//
//  SecuredPreferencesAPI.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

// MARK: - Service

public protocol SecuredPreferencesService {
    func get(_ key: SecuredPreferencesAPI.Key) -> String?
    func set(_ value: String?, forKey key: SecuredPreferencesAPI.Key) -> Bool
    func remove(_ key: SecuredPreferencesAPI.Key) -> Bool
}

// MARK: Namespace

public enum SecuredPreferencesAPI {
    
    /// Security key for compile-safe access.
    ///
    ///     extension SecuredPreferencesAPI.Key {
    ///         static let token = SecuredPreferencesAPI.Key("token")
    ///     }
    public struct Key {
        public let name: String
        
        public init(_ key: String) {
            self.name = key
        }
    }
}
