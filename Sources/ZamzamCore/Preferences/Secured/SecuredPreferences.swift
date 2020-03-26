//
//  SecuredPreferences.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

public struct SecuredPreferences: SecuredPreferencesType {
    private let service: SecuredPreferencesService
    
    public init(service: SecuredPreferencesService) {
        self.service = service
    }
}

public extension SecuredPreferences {
    
    func get(_ key: SecuredPreferencesAPI.Key, completion: @escaping (String?) -> Void) {
        service.get(key, completion: completion)
    }
    
    func set(_ value: String?, forKey key: SecuredPreferencesAPI.Key) -> Bool {
        service.set(value, forKey: key)
    }
    
    func remove(_ key: SecuredPreferencesAPI.Key) -> Bool {
        service.remove(key)
    }
}
