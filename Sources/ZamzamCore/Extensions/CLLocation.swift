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
    /// - Parameter timeout: A deadline after which the lookup is cancelled and `nil` returned,
    ///   since reverse geocoding is network-bound and can otherwise hang for minutes.
    /// - Returns: The location details, or `nil` on failure, cancellation or timeout.
    func geocoder(timeout: TimeInterval = 10) async -> LocationMeta? {
        // `CLGeocoder` is not `Sendable`, but `cancelGeocode()` is the documented way to abandon
        // an in-flight request from elsewhere, which is all the other references do.
        nonisolated(unsafe) let geocoder = CLGeocoder()

        // A task group would leave the losing child suspended until Core Location replied, so the
        // deadline is enforced by cancelling the geocode itself rather than by racing it.
        let timeoutTask = Task {
            try await Task.sleep(seconds: timeout)
            geocoder.cancelGeocode()
        }

        defer { timeoutTask.cancel() }

        let placemark = await withTaskCancellationHandler {
            try? await geocoder.reverseGeocodeLocation(self).first
        } onCancel: {
            geocoder.cancelGeocode()
        }

        guard let placemark else { return nil }

        return LocationMeta(
            coordinates: (coordinate.latitude, coordinate.longitude),
            locality: placemark.locality ?? placemark.subAdministrativeArea,
            country: placemark.country,
            countryCode: placemark.isoCountryCode,
            timeZone: placemark.timeZone,
            administrativeArea: placemark.administrativeArea
        )
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
