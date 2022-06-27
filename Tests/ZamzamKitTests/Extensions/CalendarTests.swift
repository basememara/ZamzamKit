//
//  CalendarTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2021-04-16.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class CalendarTests: XCTestCase {}

extension CalendarTests {
    func testGenerateDays() throws {
        // Given
        let dateInterval = DateInterval(
            start: Date(timeIntervalSince1970: 1617235200), // April 1, 2021 12:00:00 AM UTC
            end: Date(timeIntervalSince1970: 1619827200) // May 1, 2021 12:00:00 AM UTC
        )

        let utcCalendar: Calendar = .posix

        // When
        let utcDays = utcCalendar.generateDays(for: dateInterval)

        // Then
        XCTAssertEqual(utcDays.count, 30)
    }

    func testGenerateDaysWithLeapYear() throws {
        // Given
        let dateInterval = DateInterval(
            start: Date(timeIntervalSince1970: 1582761600), // February 27, 2020 12:00:00 AM
            end: Date(timeIntervalSince1970: 1583107200) // March 2, 2020 12:00:00 AM UTC
        )

        let utcCalendar: Calendar = .posix

        // When
        let utcDays = utcCalendar.generateDays(for: dateInterval)

        // Then
        XCTAssertEqual(utcDays.count, 4)
    }

    func testGenerateDaysWithoutLeapYear() throws {
        // Given
        let dateInterval = DateInterval(
            start: Date(timeIntervalSince1970: 1614384000), // February 27, 2021 12:00:00 AM UTC
            end: Date(timeIntervalSince1970: 1614643200) // March 2, 2021 12:00:00 AM UTC
        )

        let utcCalendar: Calendar = .posix

        // When
        let utcDays = utcCalendar.generateDays(for: dateInterval)

        // Then
        XCTAssertEqual(utcDays.count, 3)
    }
}

extension CalendarTests {
    func testGenerateWeek() throws {
        // Given
        let date = Date(timeIntervalSince1970: 1617285600) // April 1, 2021 2:00:00 PM UTC
        let utcCalendar: Calendar = .posix

        // When
        let week = utcCalendar.generateWeek(for: date)

        // Then
        XCTAssertEqual(week.count, 7)
        XCTAssertEqual(week.first, Date(timeIntervalSince1970: 1616889600))
        XCTAssertEqual(week.last, Date(timeIntervalSince1970: 1617408000))
    }

    func testGenerateWeekWithCustomFirstWeekday() throws {
        // Given
        let date = Date(timeIntervalSince1970: 1617285600) // April 1, 2021 2:00:00 PM UTC
        var utcCalendar: Calendar = .posix

        // When
        utcCalendar.firstWeekday = 3
        let week = utcCalendar.generateWeek(for: date)

        // Then
        XCTAssertEqual(week.count, 7)
        XCTAssertEqual(week.first, Date(timeIntervalSince1970: 1617062400))
        XCTAssertEqual(week.last, Date(timeIntervalSince1970: 1617580800))
    }
}
