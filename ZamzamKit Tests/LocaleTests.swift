//
//  LocaleTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/19/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import XCTest
import ZamzamKit

class LocaleTests: XCTestCase {
    
    func testPosix() {
        let test: Locale = .posix
        XCTAssertEqual(test.identifier, "en_US_POSIX")
    }
}
