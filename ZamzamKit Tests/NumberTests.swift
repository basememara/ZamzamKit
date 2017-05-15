//
//  NumberTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/14/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import XCTest
@testable import ZamzamKit

class NumberTests: XCTestCase {
    
    func testRounded() {
        let test1: Float = 123.12312421
        XCTAssertEqual(test1.rounded(toPlaces: 2), 123.12)
        
        let test2: Float = -976.23238798652
        XCTAssertEqual(test2.rounded(toPlaces: 8), -976.2323880)
        
        let test3: Float = 123.1
        XCTAssertEqual(test3.rounded(toPlaces: 2), 123.1)
        
        let test4: Double = 2341.32523
        XCTAssertEqual(test4.rounded(toPlaces: 2), 2341.33)
        
        let test5: Double = 2341.3252323423
        XCTAssertEqual(test5.rounded(toPlaces: 6), 2341.325232)
        
        let test6: Double = 234
        XCTAssertEqual(test6.rounded(toPlaces: 2), 234)

        XCTAssertEqual(Double.pi.rounded(toPlaces: 2), 3.14)
    }
}
