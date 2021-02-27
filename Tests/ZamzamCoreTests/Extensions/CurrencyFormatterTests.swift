//
//  CurrencyTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-05-07.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class CurrencyFormatterTests: XCTestCase {
    private let defaultLocale: Locale = .init(identifier: "en-US")
    private lazy var defaultFormatter = CurrencyFormatter(for: defaultLocale)
}

extension CurrencyFormatterTests {
    func testUS() {
        let formatter = CurrencyFormatter(for: defaultLocale)

        let amount: Double = 123456789.987
        XCTAssertEqual(formatter.string(fromAmount: amount), "$123,456,789.99")

        let amount2: Double = 123456789.00
        XCTAssertEqual(formatter.string(fromAmount: amount2), "$123,456,789.00")

        let amount3: Double = 123456789
        XCTAssertEqual(formatter.string(fromAmount: amount3), "$123,456,789.00")
    }

    func testCA() {
        let formatter = CurrencyFormatter(for: .init(identifier: "en-CA"))

        let amount: Double = 123456789.987
        XCTAssertEqual(formatter.string(fromAmount: amount), "$123,456,789.99")

        let amount2: Double = 123456789.00
        XCTAssertEqual(formatter.string(fromAmount: amount2), "$123,456,789.00")

        let amount3: Double = 123456789
        XCTAssertEqual(formatter.string(fromAmount: amount3), "$123,456,789.00")
    }

    func testFR() {
        let formatter = CurrencyFormatter(for: Locale(identifier: "fr-FR"))

        let amount: Double = 123456789.987
        XCTAssertEqual(formatter.string(fromAmount: amount), "123 456 789,99 €")
    }

    func testSA() {
        let formatter = CurrencyFormatter(for: Locale(identifier: "ar-SA"))

        let amount: Double = 123456789.987
        XCTAssertEqual(formatter.string(fromAmount: amount), "١٢٣٬٤٥٦٬٧٨٩٫٩٩ ر.س.‏")
    }

    func testZH() {
        let formatter = CurrencyFormatter(for: Locale(identifier: "zh_HANS_CN"))

        let amount: Double = 123456789.987
        XCTAssertEqual(formatter.string(fromAmount: amount), "¥123,456,789.99")
    }
}

extension CurrencyFormatterTests {
    func testTruncate() {
        let formatter = CurrencyFormatter(for: defaultLocale, autoTruncate: true)

        let amount: Double = 123456789.987
        XCTAssertEqual(formatter.string(fromAmount: amount), "$123,456,789.99")

        let amount2: Double = 123456789.00
        XCTAssertEqual(formatter.string(fromAmount: amount2), "$123,456,789")
    }

    func testTruncate2() {
        let formatter = CurrencyFormatter(for: Locale(identifier: "fr-FR"), autoTruncate: true)

        let amount: Double = 123456789.00
        XCTAssertEqual(formatter.string(fromAmount: amount), "123 456 789 €")
    }
}

extension CurrencyFormatterTests {
    func testZeroSymbol() {
        let formatter = CurrencyFormatter(for: defaultLocale, zeroSymbol: "---")

        let amount: Double = 123456789.987
        XCTAssertEqual(formatter.string(fromAmount: amount), "$123,456,789.99")

        XCTAssertEqual(formatter.string(fromAmount: 0), "---")
    }
}

extension CurrencyFormatterTests {
    func testPositivePrefix() {
        let formatter = CurrencyFormatter(for: defaultLocale, usePrefix: true)

        let amount: Double = 123456789.987
        XCTAssertEqual(formatter.string(fromAmount: amount), "+$123,456,789.99")

        let amount2: Double = 123456789
        XCTAssertEqual(formatter.string(fromAmount: amount2), "+$123,456,789.00")
    }

    func testNegativePrefix() {
        let formatter = CurrencyFormatter(for: defaultLocale, usePrefix: true)

        let amount: Double = -123456789.987
        XCTAssertEqual(formatter.string(fromAmount: amount), "-$123,456,789.99")

        let amount2: Double = -123456789
        XCTAssertEqual(formatter.string(fromAmount: amount2), "-$123,456,789.00")
    }
}
