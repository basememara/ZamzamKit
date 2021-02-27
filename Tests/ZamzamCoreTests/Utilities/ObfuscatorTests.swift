//
//  ApplyTests.swift
//  ZamzamCoreTests
//
//  Created by Basem Emara on 2020-08-31.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class ObfuscatorTests: XCTestCase {
    private let obfuscator = Obfuscator(salt: "ObfuscatorTests")
}

extension ObfuscatorTests {

    func testConceal() {
        let value = obfuscator.conceal(secret: "Abc123XYZ!@#)*^][.sdf")
        let expected: [UInt8] = [14, 0, 5, 68, 65, 80, 57, 45, 53, 83, 20, 70, 90, 94, 45, 18, 57, 72, 6, 23, 5]

        XCTAssertEqual(value, expected)
    }
}

extension ObfuscatorTests {

    func testReveal() {
        let value = obfuscator.reveal(
            secret: [7, 55, 94, 66, 10, 34, 40, 48, 58, 61, 33, 4, 29, 21, 25, 35, 9, 2, 95, 85, 70, 71, 42, 74, 72]
        )

        XCTAssertEqual(value, "HU87yAIDUOuanajlkd*&%&^%:")
    }
}
