//
//  PreferencesType.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2019-05-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation

public struct PreferencesDefaultsStore: PreferencesStore {
    private let defaults: UserDefaults
    
    public init(defaults: UserDefaults) {
        self.defaults = defaults
    }
}

public extension PreferencesDefaultsStore {
    
    func get<T>(_ key: PreferencesAPI.Key<T?>) -> T? {
        defaults.object(forKey: key.name) as? T
    }
    
    func set<T>(_ value: T?, forKey key: PreferencesAPI.Key<T?>) {
        guard let value = value else { return remove(key) }
        defaults.set(value, forKey: key.name)
    }
    
    func remove<T>(_ key: PreferencesAPI.Key<T?>) {
        defaults.removeObject(forKey: key.name)
    }
}
