//
//  CLLocation.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import CoreLocation.CLGeocoder
import CoreLocation.CLLocation
import Foundation

public extension CLLocationCoordinate2D {
    
    /// Returns a location object.
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    /// Returns the distance (measured in meters) from the receiver’s location to the specified location.
    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        location.distance(from: coordinate.location)
    }
}

public extension Array where Element == CLLocationCoordinate2D {
    
    /// Returns the closest coordinate to the specified location.
    ///
    /// If the sequence has no elements, returns nil.
    func closest(to coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D? {
        self.min { $0.distance(from: coordinate) < $1.distance(from: coordinate) }
    }
    
    /// Returns the farthest coordinate from the specified location.
    ///
    /// If the sequence has no elements, returns nil.
    func farthest(from coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D? {
        self.max { $0.distance(from: coordinate) < $1.distance(from: coordinate) }
    }
}

public extension CLLocation {
    
    struct LocationMeta: CustomStringConvertible {
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
    
    /// Retrieves location details for coordinates.
    ///
    /// - Parameters:
    ///   - timeout: A timeout to exit and call completion handler. Default is 10 seconds.
    ///   - completion: Async callback with retrived location details.
    func geocoder(timeout: TimeInterval = 10, completion: @escaping (LocationMeta?) -> Void) {
        var hasCompleted = false
        
        // Fallback on timeout since could take too long
        // https://stackoverflow.com/a/34389742
        let timer = Timer(timeInterval: timeout, repeats: false) { timer in
            defer { timer.invalidate() }
            
            guard !hasCompleted else { return }
            hasCompleted = true
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }
        
        // Reverse geocode stored coordinates
        CLGeocoder().reverseGeocodeLocation(self) { placemarks, error in
            DispatchQueue.main.async {
                // Destroy timeout mechanism
                guard !hasCompleted else { return }
                hasCompleted = true
                timer.invalidate()
                
                guard let mark = placemarks?.first, error == nil else {
                    return completion(nil)
                }
                
                completion(
                    .init(
                        coordinates: (self.coordinate.latitude, self.coordinate.longitude),
                        locality: mark.locality,
                        country: mark.country,
                        countryCode: mark.isoCountryCode,
                        timeZone: mark.timeZone,
                        administrativeArea: mark.administrativeArea
                    )
                )
            }
        }
        
        // Start timer
        RunLoop.current.add(timer, forMode: .default)
    }
}

extension CLLocationCoordinate2D: Equatable {
    
    /// Determine if coordinates match using latitude and longitude values.
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    /// Determine if coordinates do not match using latitude and longitude values.
    public static func != (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        !(lhs == rhs)
    }
}

public extension CLLocationCoordinate2D {
    // About 100 meters accuracy
    // https://gis.stackexchange.com/a/8674
    private static let decimalPrecision = 3
    
    /// Approximate comparison of coordinates rounded to 3 decimal places.
    static func ~~ (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude.rounded(toPlaces: CLLocationCoordinate2D.decimalPrecision)
            == rhs.latitude.rounded(toPlaces: CLLocationCoordinate2D.decimalPrecision)
                && lhs.longitude.rounded(toPlaces: CLLocationCoordinate2D.decimalPrecision)
                    == rhs.longitude.rounded(toPlaces: CLLocationCoordinate2D.decimalPrecision)
    }
    
    /// Approximate comparison of coordinates rounded to 3 decimal places.
    static func !~ (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        !(lhs ~~ rhs)
    }
}

extension CLLocationCoordinate2D: CustomStringConvertible {
    
    public var description: String {
        .localizedStringWithFormat("%.2f°, %.2f°", latitude, longitude)
    }
}
