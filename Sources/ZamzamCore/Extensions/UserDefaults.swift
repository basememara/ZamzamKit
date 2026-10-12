//
//  UserDefaults.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-01-23.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSUserDefaults

public extension UserDefaults {
    /// Returns a boolean value indicating whether the defaults contains the given key.
    func contains(_ key: String) -> Bool {
        object(forKey: key) != nil
    }
}