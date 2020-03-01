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
    
    func get<T>(_ key: String.Key<T?>) -> T? {
        defaults[key]
    }
    
    func set<T>(_ value: T?, forKey key: String.Key<T?>) {
        defaults[key] = value
    }
    
    func remove<T>(_ key: String.Key<T?>) {
        defaults.remove(key)
    }
}
