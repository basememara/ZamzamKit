//
//  ApplyTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class ApplyTests: XCTestCase {
    func testApply() {
        let model = SomeModel().apply {
            $0.propertyA = "abc"
            $0.propertyB = 5
            $0.propertyC = true
        }

        XCTAssertEqual(model.propertyA, "abc")
        XCTAssertEqual(model.propertyB, 5)
        XCTAssertEqual(model.propertyC, true)
    }
}

private extension ApplyTests {
    class SomeModel: Apply {
        var propertyA: String?
        var propertyB: Int?
        var propertyC: Bool?
    }
}
