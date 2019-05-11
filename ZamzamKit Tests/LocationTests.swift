//
//  LocationTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import XCTest
import CoreLocation
import ZamzamKit

class LocationTests: XCTestCase {
    
}

extension LocationTests {
    
    func testMetaData() {
        let promise = expectation(description: "fetch location")
        let value = CLLocation(latitude: 43.7, longitude: -79.4)
        let expected = "Toronto, CA"
    
        value.geocoder {
            defer { promise.fulfill() }
            
            guard let locality = $0?.locality,
                let countryCode = $0?.countryCode else {
                    XCTFail("Could not retrieve address meta data.")
                    return
            }
            
            XCTAssertEqual("\(locality), \(countryCode)", expected,
                "The location should be \(expected)")
            
            XCTAssertEqual($0?.description, expected,
                "The location should be \(expected)")
            
            XCTAssertEqual($0?.timeZone?.identifier, "America/Toronto")
        }
        
        waitForExpectations(timeout: 5.0)
    }
}

extension LocationTests {
    
    func testClosestFarthestLocation() {
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
        
        XCTAssertEqual(
            [newYork, miami, atlanta].closest(to: toronto)!.latitude,
            newYork.latitude
        )
        
        XCTAssertEqual(
            [newYork, miami, atlanta].farthest(from: toronto)!.latitude,
            miami.latitude
        )
        
        XCTAssertEqual(
            [paris, london, cairo].closest(to: beijing)!.latitude,
            cairo.latitude
        )
        
        XCTAssertEqual(
            [paris, london, cairo].farthest(from: beijing)!.latitude,
            paris.latitude
        )
        
        XCTAssertEqual(
            [vancouver, losAngles, miami].closest(to: tokyo)!.latitude,
            vancouver.latitude
        )
        
        XCTAssertEqual(
            [vancouver, losAngles, miami].farthest(from: tokyo)!.latitude,
            miami.latitude
        )
    }
}

extension LocationTests {
    
    func testDistanceLocation() {
        let toronto = CLLocationCoordinate2D(latitude: 43.6529, longitude: -79.3849)
        let newYork = CLLocationCoordinate2D(latitude: 40.7648, longitude: -73.9808)
        let vancouver = CLLocationCoordinate2D(latitude: 49.2609, longitude: -123.1139)
        let beijing = CLLocationCoordinate2D(latitude: 39.905, longitude: 116.39139)
        
        XCTAssertEqual(Int(toronto.distance(from: newYork)), 549_413)
        XCTAssertEqual(Int(vancouver.distance(from: beijing)), 8_538_317)
    }
}

extension LocationTests {
    
    func testApproximateComparison() {
        let coordinate1 = CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832)
        let coordinate2 = CLLocationCoordinate2D(latitude: 43.6531, longitude: -79.3834)
        let coordinate3 = CLLocationCoordinate2D(latitude: 43.6522, longitude: -79.3822)
        
        XCTAssertTrue(coordinate1 ~~ coordinate2)
        XCTAssertFalse(coordinate1 ~~ coordinate3)
    }
}
