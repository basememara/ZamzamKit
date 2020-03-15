//
//  ColorTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 10/13/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

#if canImport(UIKit)
    import UIKit
#elseif os(OSX)
    import AppKit
    typealias UIColor = NSColor
#endif

final class ColorTests: XCTestCase {

}

extension ColorTests {

    func testRGBVsHex() {
        XCTAssertEqual(UIColor(rgb: (77, 116, 107)), UIColor(hex: 0x4D746B))
    }
}

extension ColorTests {

    func testRandom() {
        XCTAssertNotEqual(UIColor.random, .random)
    }
}
