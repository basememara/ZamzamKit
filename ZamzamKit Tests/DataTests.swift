//
//  DataTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam. All rights reserved.
//

import XCTest
import ZamzamKit

class DataTests: XCTestCase {
    
    func testString() {
        let dataFromString = "hello".data(using: .utf8)
        XCTAssertNotNil(dataFromString)
        XCTAssertNotNil(dataFromString?.string(encoding: .utf8))
        XCTAssertEqual(dataFromString?.string(encoding: .utf8), "hello")
    }
}
