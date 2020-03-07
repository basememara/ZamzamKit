//
//  SecuredPreferences.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2020-03-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation

public struct SecuredPreferences: SecuredPreferencesType {
    private let store: SecuredPreferencesStore
    
    public init(store: SecuredPreferencesStore) {
        self.store = store
    }
}

public extension SecuredPreferences {
    
    func get(_ key: SecuredPreferencesAPI.Key, completion: @escaping (String?) -> Void) {
        store.get(key, completion: completion)
    }
    
    func set(_ value: String?, forKey key: SecuredPreferencesAPI.Key) -> Bool {
        store.set(value, forKey: key)
    }
    
    func remove(_ key: SecuredPreferencesAPI.Key) -> Bool {
        store.remove(key)
    }
}
