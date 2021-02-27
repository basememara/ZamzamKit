//
//  LocaleTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 4/19/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class LocaleTests: XCTestCase {

    func testPosix() {
        let test: Locale = .posix
        XCTAssertEqual(test.identifier, "en_US_POSIX")
    }
}
