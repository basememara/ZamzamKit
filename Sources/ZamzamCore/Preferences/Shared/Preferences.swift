//
//  Preferences.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2019-05-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public struct Preferences: PreferencesType {
    private let store: PreferencesStore
    
    public init(store: PreferencesStore) {
        self.store = store
    }
}

public extension Preferences {
    
    func get<T>(_ key: PreferencesAPI.Key<T?>) -> T? {
        store.get(key)
    }
    
    func set<T>(_ value: T?, forKey key: PreferencesAPI.Key<T?>) {
        store.set(value, forKey: key)
    }
    
    func remove<T>(_ key: PreferencesAPI.Key<T?>) {
        store.remove(key)
    }
}
