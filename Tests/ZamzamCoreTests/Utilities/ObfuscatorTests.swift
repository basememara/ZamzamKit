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
    private let obfuscator = Obfuscator(salt: "\(Bool.self)|\(Int.self)|\(String.self)")
}

extension ObfuscatorTests {
    func testConceal() {
        let value = obfuscator.conceal(secret: "Abc123XYZ!@#)*^][.sdf")
        let expected: [UInt8] = [3, 13, 12, 93, 78, 122, 54, 45, 38, 114, 52, 81, 64, 68, 57, 31, 52, 65, 31, 24, 47]

        XCTAssertEqual(value, expected)
    }
}

extension ObfuscatorTests {
    func testReveal() {
        let value = obfuscator.reveal(
            secret: [10, 58, 87, 91, 5, 8, 39, 48, 41, 28, 1, 19, 7, 15, 13, 46, 4, 11, 70, 90, 108, 72, 42, 89, 105]
        )

        XCTAssertEqual(value, "HU87yAIDUOuanajlkd*&%&^%:")
    }
}
