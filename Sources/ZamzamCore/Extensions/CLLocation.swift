//
//  CLLocation.swift
//  ZamzamCore
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
    struct LocationMeta: CustomStringConvertible, Sendable {
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
    /// - Parameter timeout: A timeout after which `nil` is returned, since reverse
    ///   geocoding is network-bound and can take arbitrarily long. Default is 10 seconds.
    /// - Returns: The location details, or `nil` on failure or timeout.
    func geocoder(timeout: TimeInterval = 10) async -> LocationMeta? {
        await withTaskGroup(of: LocationMeta?.self) { group in
            group.addTask {
                guard let mark = try? await CLGeocoder().reverseGeocodeLocation(self).first else { return nil }

                return LocationMeta(
                    coordinates: (self.coordinate.latitude, self.coordinate.longitude),
                    locality: mark.locality ?? mark.subAdministrativeArea,
                    country: mark.country,
                    countryCode: mark.isoCountryCode,
                    timeZone: mark.timeZone,
                    administrativeArea: mark.administrativeArea
                )
            }

            group.addTask {
                try? await Task.sleep(seconds: timeout)
                return nil
            }

            defer { group.cancelAll() }
            return await group.next() ?? nil
        }
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
    /// Determine if coordinates match using latitude and longitude values.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    /// Determine if coordinates do not match using latitude and longitude values.
    public static func != (lhs: Self, rhs: Self) -> Bool {
        !(lhs == rhs)
    }
}

extension CLLocationCoordinate2D: @retroactive CustomStringConvertible {
    public var description: String {
        .localizedStringWithFormat("%.2f°, %.2f°", latitude, longitude)
    }
}
