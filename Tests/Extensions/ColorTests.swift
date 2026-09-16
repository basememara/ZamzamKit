//
//  ColorTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 10/13/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct ColorTests {}

extension ColorTests {
    @Test
    func rGBVsHex() {
        #expect(PlatformColor(rgb: (77, 116, 107)) == PlatformColor(hex: 0x4D746B))
    }
}

extension ColorTests {
    @Test
    func random() {
        #expect(PlatformColor.random != .random)
    }
}
