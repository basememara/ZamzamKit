//
//  CLLocation.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import CoreLocation

public extension CLLocation {
    
    /**
     Retrieves location details for coordinates.
     
     - parameter completion: Async callback with retrived location details.
     */
    func geocoder(completion: @escaping (LocationMeta?) -> Void) {
        // Reverse geocode stored coordinates
        CLGeocoder().reverseGeocodeLocation(self) { placemarks, error in
            DispatchQueue.main.async {
                guard let mark = placemarks?.first, error == nil else { return completion(nil) }
                
                completion(LocationMeta(
                    coordinates: (self.coordinate.latitude, self.coordinate.longitude),
                    locality: mark.locality,
                    country: mark.country,
                    countryCode: mark.isoCountryCode,
                    timeZone: mark.timeZone,
                    administrativeArea: mark.administrativeArea)
                )
            }
        }
    }
}
