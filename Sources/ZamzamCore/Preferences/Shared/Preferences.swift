//
//  Preferences.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-05-09.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public struct Preferences: PreferencesType {
    private let service: PreferencesService
    
    public init(service: PreferencesService) {
        self.service = service
    }
}

public extension Preferences {
    
    func get<T>(_ key: PreferencesAPI.Key<T?>) -> T? {
        service.get(key)
    }
    
    func set<T>(_ value: T?, forKey key: PreferencesAPI.Key<T?>) {
        service.set(value, forKey: key)
    }
    
    func remove<T>(_ key: PreferencesAPI.Key<T?>) {
        service.remove(key)
    }
}
