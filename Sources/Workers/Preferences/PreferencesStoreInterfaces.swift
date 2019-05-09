//
//  PreferencesStoreInterfaces.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2019-05-09.
//  Copyright © 2019 Zamzam. All rights reserved.
//

public protocol PreferencesStore {
    func get<T>(_ key: UserDefaults.Key<T?>) -> T?
    func set<T>(_ value: T?, forKey key: UserDefaults.Key<T?>)
    func remove<T>(_ key: UserDefaults.Key<T?>)
}

public protocol PreferencesType: PreferencesStore {
    
}
