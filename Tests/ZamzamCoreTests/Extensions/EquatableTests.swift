//
//  EquatableTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2019-05-13.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class EquatableTests: XCTestCase {
    
    func testEquatableWithin() {
        XCTAssert("def".within(["abc", "def", "ghi"]))
        XCTAssert(!"xyz".within(["abc", "def", "ghi"]))
    }
}
