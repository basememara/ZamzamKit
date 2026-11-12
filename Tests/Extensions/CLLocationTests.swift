//
//  LocationTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import CoreLocation
import Foundation
import Testing
@testable import ZamzamCore

struct CLLocationTests {}

extension CLLocationTests {
    @Test
    func metaData() async throws {
        // Given
        let value = CLLocation(latitude: 43.7, longitude: -79.4)

        let placemark = Placemark(
            locality: "Toronto",
            subAdministrativeArea: "Toronto Division",
            country: "Canada",
            isoCountryCode: "CA",
            timeZone: TimeZone(identifier: "America/Toronto"),
            administrativeArea: "ON"
        )

        // When
        let meta = try #require(await value.locationMeta(timeout: 5) { placemark } cancel: {})

        // Then
        #expect(meta.coordinates?.latitude == 43.7)
        #expect(meta.coordinates?.longitude == -79.4)
        #expect(meta.locality == "Toronto")
        #expect(meta.country == "Canada")
        #expect(meta.countryCode == "CA")
        #expect(meta.timeZone?.identifier == "America/Toronto")
        #expect(meta.administrativeArea == "ON")
    }

    @Test
    func metaDataNamesTheSubAdministrativeAreaWithoutALocality() async throws {
        // Given
        let value = CLLocation(latitude: 43.7, longitude: -79.4)
        let placemark = Placemark(subAdministrativeArea: "Toronto Division", country: "Canada", isoCountryCode: "CA")

        // When
        let meta = try #require(await value.locationMeta(timeout: 5) { placemark } cancel: {})

        // Then
        #expect(meta.locality == "Toronto Division")
    }

    @Test
    func metaDataIsNilWithoutAPlacemark() async {
        // Given
        let value = CLLocation(latitude: 43.7, longitude: -79.4)

        // When
        let meta = await value.locationMeta(timeout: 5) { Placemark?.none } cancel: {}

        // Then
        #expect(meta == nil)
    }

    @Test(.timeLimit(.minutes(1)))
    func metaDataIsNilOnceTheTimeoutCancelsTheLookup() async {
        // Given
        let value = CLLocation(latitude: 43.7, longitude: -79.4)
        let (inFlight, lookup) = AsyncStream.makeStream(of: Void.self)

        await confirmation { cancelled in
            // When: like a geocode that never hears back, the lookup only ends once it is cancelled
            let meta = await value.locationMeta(timeout: 0.05) {
                for await _ in inFlight {}
                return Placemark?.none
            } cancel: {
                cancelled()
                lookup.finish()
            }

            // Then
            #expect(meta == nil)
        }
    }

    @Test
    func metaDescription() {
        let meta = CLLocation.LocationMeta(locality: "Toronto", country: "Canada", countryCode: "CA")

        #expect(meta.description == "Toronto, CA")
    }
}

extension CLLocationTests {
    @Test
    func closestFarthestLocation() throws {
        let toronto = CLLocationCoordinate2D(latitude: 43.6529, longitude: -79.3849)
        let newYork = CLLocationCoordinate2D(latitude: 40.7648, longitude: -73.9808)
        let miami = CLLocationCoordinate2D(latitude: 25.7743, longitude: -80.1937)
        let atlanta = CLLocationCoordinate2D(latitude: 33.7491, longitude: -84.3902)
        let vancouver = CLLocationCoordinate2D(latitude: 49.2609, longitude: -123.1139)
        let losAngles = CLLocationCoordinate2D(latitude: 32.673296, longitude: -114.1395)
        let paris = CLLocationCoordinate2D(latitude: 48.859489, longitude: 2.320582)
        let london = CLLocationCoordinate2D(latitude: 51.50722, longitude: -0.1275)
        let beijing = CLLocationCoordinate2D(latitude: 39.905, longitude: 116.39139)
        let tokyo = CLLocationCoordinate2D(latitude: 35.54843, longitude: 139.78041)
        let cairo = CLLocationCoordinate2D(latitude: 30.05611, longitude: 31.23944)

        #expect(try #require([newYork, miami, atlanta].closest(to: toronto)).latitude == newYork.latitude)

        #expect(try #require([newYork, miami, atlanta].farthest(from: toronto)).latitude == miami.latitude)

        #expect(try #require([paris, london, cairo].closest(to: beijing)).latitude == cairo.latitude)

        #expect(try #require([paris, london, cairo].farthest(from: beijing)).latitude == paris.latitude)

        #expect(try #require([vancouver, losAngles, miami].closest(to: tokyo)).latitude == vancouver.latitude)

        #expect(try #require([vancouver, losAngles, miami].farthest(from: tokyo)).latitude == miami.latitude)
    }
}

extension CLLocationTests {
    @Test
    func distanceLocation() {
        let toronto = CLLocationCoordinate2D(latitude: 43.6529, longitude: -79.3849)
        let newYork = CLLocationCoordinate2D(latitude: 40.7648, longitude: -73.9808)
        let vancouver = CLLocationCoordinate2D(latitude: 49.2609, longitude: -123.1139)
        let beijing = CLLocationCoordinate2D(latitude: 39.905, longitude: 116.39139)

        #expect(Int(toronto.distance(from: newYork)) == 549_413)
        #expect(Int(vancouver.distance(from: beijing)) == 8_538_317)
    }
}

private struct Placemark: GeocodedPlacemark {
    var locality: String?
    var subAdministrativeArea: String?
    var country: String?
    var isoCountryCode: String?
    var timeZone: TimeZone?
    var administrativeArea: String?
}
