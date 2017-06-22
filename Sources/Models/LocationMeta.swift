//
//  LocationMeta.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/18/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public struct LocationMeta: CustomStringConvertible {
    public var coordinates: (latitude: Double, longitude: Double)?
    public var locality: String?
    public var country: String?
    public var countryCode: String?
    public var timeZone: TimeZone?
    public var administrativeArea: String?
    
    public var description: String {
        if let l = locality, let c = (Locale.current.languageCode == "en" ? countryCode : country) {
            return "\(l), \(c)"
        } else if let l = locality {
            return "\(l)"
        } else if let c = country {
            return "\(c)"
        }
        
        return ""
    }
}
