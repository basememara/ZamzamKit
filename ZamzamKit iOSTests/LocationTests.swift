//
//  LocationTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit
import CoreLocation
import XCTest
@testable import ZamzamKit

class LocationTests: XCTestCase {
    
    func testMetaData() {
        let expectation = self.expectationWithDescription("fetch location")
        let value = CLLocation(latitude: 43.7, longitude: -79.4)
        let expected = "Toronto, CA"
    
        value.getMeta { (location: LocationMeta?) in
            defer {
                expectation.fulfill()
            }
            
            guard let locality = location?.locality,
                let countryCode = location?.countryCode else {
                    XCTFail("Could not retrieve address meta data.")
                    return
            }
            
            XCTAssertEqual("\(locality), \(countryCode)", expected,
                "The location should be \(expected)")
        }
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }

    
}
