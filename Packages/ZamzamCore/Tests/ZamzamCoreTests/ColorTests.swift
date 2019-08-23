//
//  ColorTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 10/13/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class ColorTests: XCTestCase {

}

extension ColorTests {

    func testRGBVsHex() {
        XCTAssertEqual(UIColor(rgb: (77, 116, 107)), UIColor(hex: 0x4D746B))
    }
}
