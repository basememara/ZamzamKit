//
//  ColorTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 10/13/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class ColorTests: XCTestCase {}

extension ColorTests {

    func testRGBVsHex() {
        XCTAssertEqual(PlatformColor(rgb: (77, 116, 107)), PlatformColor(hex: 0x4D746B))
    }
}

extension ColorTests {

    func testRandom() {
        XCTAssertNotEqual(PlatformColor.random, .random)
    }
}
