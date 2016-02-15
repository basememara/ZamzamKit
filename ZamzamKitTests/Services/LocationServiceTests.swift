//
//  FileServiceTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import XCTest
@testable import ZamzamKit

class LocationServiceTests: XCTestCase {
    
    var manager: ZamzamManager!
    
    override func setUp() {
        super.setUp()
        
        manager = ZamzamManager()
    }
    
    func testGetDistanceBetweenCoordinates() {
        assertDistanceBetweenCoordinates(
            [43.7, 79.4], [37.3175, 122.0419], expected: 3633.0)
    }
    
    func testGetDistanceBetweenCoordinates2() {
        assertDistanceBetweenCoordinates(
            [40.7486, -73.9864], [21.4225, 39.8262], expected: 10300.0)
    }
    
    func testGetDistanceBetweenCoordinatesWithZero() {
        assertDistanceBetweenCoordinates(
            [0.0, 0.0], [21.4225, 39.8262], expected: 4933.0)
    }
    
    func assertDistanceBetweenCoordinates(from: [Double], _ to: [Double], expected: Double) {
        let value = manager.locationService.getDistanceBetweenCoordinates(from, to)

        // Verify distance between two coordinates:
        // http://www.movable-type.co.uk/scripts/latlong.html
        
        XCTAssertEqualWithAccuracy(round(value), expected,
            accuracy: 10, // Allowed difference in kilometers
            "Distance should be \(expected)")
    }
}
