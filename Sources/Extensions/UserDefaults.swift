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
    func update(values: [String: Any]) {
        values.forEach { setValue($0.value, forKey: $0.key) }
    }
    
    /**
     Stores the updated values from the tuple to the user defaults.
     
     - parameter values: The user default keys and values.
     */
    func update(values: [(String, Any)]) {
        update(values: Dictionary(values))
    }
    
    /**
     Adds the registrationDictionary to the last item in every search list. This means that after NSUserDefaults has looked for a value in every other valid location, it will look in registered defaults, making them useful as a "fallback" value. Registered defaults are never stored between runs of an application, and are visible only to the application that registers them.
     
     - parameter registrationDictionary: Values for user defaults.
     - parameter plistName: property list where defaults are declared
     - parameter bundle: bundle where defaults reside
     */
    func register(plist: String, inDirectory: String? = nil, bundle: Bundle? = nil) {
        let settings = Bundle.contents(plist: plist, inDirectory: inDirectory, bundle: bundle)
        self.register(defaults: settings)
    }
    
}
