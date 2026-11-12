//
//  DateFormatterTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2026-11-12.
//  Copyright © 2026 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct DateFormatterTests {
    /// June 2, 2022 at 2:54 PM UTC
    private let date = Date(timeIntervalSince1970: 1_654_181_665)
    private let calendar = Calendar(identifier: .gregorian, timeZone: .gmt)
}

extension DateFormatterTests {
    /// Japanese writes the year first and Finnish separates hours from minutes with a period, unlike the machine's
    /// locale in either test configuration.
    @Test
    func aTemplateIsResolvedInTheLocalePassed() {
        let japanese = DateFormatter(dateFormatTemplate: "yMMMd", calendar: calendar, locale: Locale(identifier: "ja_JP"))
        let finnish = DateFormatter(dateFormatTemplate: "Hmm", calendar: calendar, locale: Locale(identifier: "fi_FI"))

        #expect(japanese.string(from: date) == "2022年6月2日")
        #expect(finnish.string(from: date) == "14.54")
    }

    @Test(arguments: ["ja_JP", "fi_FI", "de_DE", "ar_SA", "en_US", "en_GB"])
    func aTemplateResolvesToTheFormatTheLocaleGivesIt(identifier: String) {
        let locale = Locale(identifier: identifier)

        let formatter = DateFormatter(dateFormatTemplate: "yMMMdjmm", calendar: calendar, locale: locale)

        #expect(formatter.dateFormat == DateFormatter.dateFormat(fromTemplate: "yMMMdjmm", options: 0, locale: locale))
    }

    @Test
    func aTemplateWithoutALocaleTakesTheCalendars() {
        let finnishCalendar = Calendar(identifier: .gregorian, timeZone: .gmt, locale: Locale(identifier: "fi_FI"))

        let formatter = DateFormatter(dateFormatTemplate: "Hmm", calendar: finnishCalendar)

        #expect(formatter.string(from: date) == "14.54")
    }
}
