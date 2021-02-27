//
//  StringInterpolationTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-11.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class StringInterpolationTests: XCTestCase {

    func testTimestamp() {
        // Given
        let date = Date(timeIntervalSinceReferenceDate: 123456789.123)

        // When
        let output = "\(timestamp: date)"

        // Then
        XCTAssertEqual(output, "2004-11-29 21:33:09.123")
    }
}
