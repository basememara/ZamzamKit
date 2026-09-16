//
//  CurrencyTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-05-07.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct CurrencyFormatterTests {
    private let defaultLocale: Locale = .init(identifier: "en-US")
    private lazy var defaultFormatter = CurrencyFormatter(for: defaultLocale)
}

extension CurrencyFormatterTests {
    @Test
    func uS() {
        let formatter = CurrencyFormatter(for: defaultLocale)

        let amount: Double = 123456789.987
        #expect(formatter.string(fromAmount: amount) == "$123,456,789.99")

        let amount2: Double = 123456789.00
        #expect(formatter.string(fromAmount: amount2) == "$123,456,789.00")

        let amount3: Double = 123456789
        #expect(formatter.string(fromAmount: amount3) == "$123,456,789.00")
    }

    @Test
    func cA() {
        let formatter = CurrencyFormatter(for: .init(identifier: "en-CA"))

        let amount: Double = 123456789.987
        #expect(formatter.string(fromAmount: amount) == "$123,456,789.99")

        let amount2: Double = 123456789.00
        #expect(formatter.string(fromAmount: amount2) == "$123,456,789.00")

        let amount3: Double = 123456789
        #expect(formatter.string(fromAmount: amount3) == "$123,456,789.00")
    }

    @Test
    func fR() {
        let formatter = CurrencyFormatter(for: Locale(identifier: "fr-FR"))

        let amount: Double = 123456789.987
        #expect(formatter.string(fromAmount: amount) == "123 456 789,99 €")
    }

    @Test
    func sA() throws {
        let formatter = CurrencyFormatter(for: Locale(identifier: "ar-SA"))

        let amount: Double = 123456789.987
        let value = formatter.string(fromAmount: amount)

        // ICU moves the directional marks between releases; the digits, separators and symbol may not
        let directionalMarks = CharacterSet(charactersIn: "\u{200E}\u{200F}\u{061C}")
        let visible = String(String.UnicodeScalarView(value.unicodeScalars.filter { !directionalMarks.contains($0) }))
        #expect(visible.contains("١٢٣٬٤٥٦٬٧٨٩٫٩٩"))
        #expect(visible.contains("ر.س."))
    }

    @Test
    func zH() {
        let formatter = CurrencyFormatter(for: Locale(identifier: "zh_HANS_CN"))

        let amount: Double = 123456789.987
        #expect(formatter.string(fromAmount: amount) == "¥123,456,789.99")
    }
}

extension CurrencyFormatterTests {
    @Test
    func truncate() {
        let formatter = CurrencyFormatter(for: defaultLocale, autoTruncate: true)

        let amount: Double = 123456789.987
        #expect(formatter.string(fromAmount: amount) == "$123,456,789.99")

        let amount2: Double = 123456789.00
        #expect(formatter.string(fromAmount: amount2) == "$123,456,789")
    }

    @Test
    func truncate2() {
        let formatter = CurrencyFormatter(for: Locale(identifier: "fr-FR"), autoTruncate: true)

        let amount: Double = 123456789.00
        #expect(formatter.string(fromAmount: amount) == "123 456 789 €")
    }
}

extension CurrencyFormatterTests {
    @Test
    func zeroSymbol() {
        let formatter = CurrencyFormatter(for: defaultLocale, zeroSymbol: "---")

        let amount: Double = 123456789.987
        #expect(formatter.string(fromAmount: amount) == "$123,456,789.99")

        #expect(formatter.string(fromAmount: 0) == "---")
    }
}

extension CurrencyFormatterTests {
    @Test
    func positivePrefix() {
        let formatter = CurrencyFormatter(for: defaultLocale, usePrefix: true)

        let amount: Double = 123456789.987
        #expect(formatter.string(fromAmount: amount) == "+$123,456,789.99")

        let amount2: Double = 123456789
        #expect(formatter.string(fromAmount: amount2) == "+$123,456,789.00")
    }

    @Test
    func negativePrefix() {
        let formatter = CurrencyFormatter(for: defaultLocale, usePrefix: true)

        let amount: Double = -123456789.987
        #expect(formatter.string(fromAmount: amount) == "-$123,456,789.99")

        let amount2: Double = -123456789
        #expect(formatter.string(fromAmount: amount2) == "-$123,456,789.00")
    }
}
