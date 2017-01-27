//
//  NSUserDefaults.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/18/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension UserDefaults {
    
    /**
     Stores the updated values from the dictionary to the user defaults.
     
     - parameter values: The user default keys and values.
     */
    func update(_ values: [String: Any]) {
        for item in values {
            self.setValue(item.1, forKey: item.0)
        }
    }
    
    /**
     Stores the updated values from the tuple to the user defaults.
     
     - parameter values: The user default keys and values.
     */
    func update(_ values: [(String, Any)]) {
        update(Dictionary(values))
    }
    
    /**
     Adds the registrationDictionary to the last item in every search list. This means that after NSUserDefaults has looked for a value in every other valid location, it will look in registered defaults, making them useful as a "fallback" value. Registered defaults are never stored between runs of an application, and are visible only to the application that registers them.
     
     - parameter registrationDictionary: Values for user defaults.
     - parameter plistName: property list where defaults are declared
     - parameter bundle: bundle where defaults reside
     */
    func registerDefaults(_ plistName: String, inDirectory: String? = nil, bundle: Bundle? = nil) {
        let settings = Bundle.contentsOfFile(plistName, inDirectory: inDirectory, bundle: bundle)
        self.register(defaults: settings)
    }
    
}
