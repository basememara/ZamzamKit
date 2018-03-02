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

public extension CLLocationCoordinate2D {
    
    /// Returns a location object.
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    /// Returns the distance (measured in meters) from the receiver’s location to the specified location.
    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        return location.distance(from: coordinate.location)
    }
}

public extension Array where Element == CLLocationCoordinate2D {
    
    /// Returns the closest coordinate to the specified location.
    func closest(to coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D? {
        return self.min { $0.distance(from: coordinate) < $1.distance(from: coordinate) }
    }
    
    /// Returns the farthest coordinate from the specified location.
    func farthest(from coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D? {
        return self.max { $0.distance(from: coordinate) > $1.distance(from: coordinate) }
    }
}

public extension CLLocationCoordinate2D {
    // About 100 meters accuracy
    // https://gis.stackexchange.com/a/8674
    private static let decimalPrecision = 3
    
    /// Approximate comparison of coordinates rounded to 3 decimal places.
    static func ~~(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude.rounded(toPlaces: CLLocationCoordinate2D.decimalPrecision)
            == rhs.latitude.rounded(toPlaces: CLLocationCoordinate2D.decimalPrecision)
            && lhs.longitude.rounded(toPlaces: CLLocationCoordinate2D.decimalPrecision)
                == rhs.longitude.rounded(toPlaces: CLLocationCoordinate2D.decimalPrecision)
    }
    
    /// Approximate comparison of coordinates rounded to 3 decimal places.
    static func !~(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return !(lhs ~~ rhs)
    }
}
