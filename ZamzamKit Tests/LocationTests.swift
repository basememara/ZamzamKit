//
//  LocationTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ZamzamKit

class LocationTests: XCTestCase {
    
    func testMetaData() {
        let asyncExpect = expectation(description: "fetch location")
        let value = CLLocation(latitude: 43.7, longitude: -79.4)
        let expected = "Toronto, CA"
    
        value.geocoder {
            defer { asyncExpect.fulfill() }
            
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
