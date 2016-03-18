//
//  NSUserDefaults.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/18/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension NSUserDefaults {
    
    /**
     Stores the updated values from the dictionary to the user defaults.
     
     - parameter values: The user default keys and values.
     */
    public func update(values: [String: AnyObject]) {
        for item in values {
            self.setValue(item.1, forKey: item.0)
        }
    }
    
    /**
     Stores the updated values from the tuple to the user defaults.
     
     - parameter values: The user default keys and values.
     */
    public func update(values: [(String, AnyObject)]) {
        update(Dictionary(values))
    }
    
}