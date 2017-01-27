//
//  CLLocation.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//
import Foundation
import CoreLocation

public extension CLLocation {
    
    /**
     Retrieves location name for a place
     
     - parameter coordinates: Latitude and longitude] coordinates
     - parameter completion: Async callback with retrived data
     */
    func getMeta(_ handler: @escaping (_ locationMeta: LocationMeta?) -> Void) {
        // Reverse geocode stored coordinates
        CLGeocoder().reverseGeocodeLocation(self) { placemarks, error in
            // Validate values
            guard let mark = placemarks?[0], error == nil else {
                return handler(nil)
            }
            
            // Get timezone if applicable
            var timezone: String?
            if mark.description != "" {
                let desc = mark.description
                
                // Extract timezone description
                if let regex = try? NSRegularExpression(
                    pattern: "identifier = \"([a-z]*\\/[a-z]*_*[a-z]*)\"",
                    options: .caseInsensitive),
                    let result = regex.firstMatch(in: desc, options: [], range: NSMakeRange(0, desc.characters.count)) {
                        let tz = (desc as NSString).substring(with: result.rangeAt(1))
                        timezone = tz.replacingOccurrences(of: "_", with: " ")
                }
            }
            
            // Process callback
            handler(LocationMeta(
                coordinates: (self.coordinate.latitude, self.coordinate.longitude),
                locality: mark.locality,
                country: mark.country,
                countryCode: mark.isoCountryCode,
                timezone: timezone,
                administrativeArea: mark.administrativeArea))
        }
    }
    
}
