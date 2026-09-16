//
//  CalendarTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2021-04-16.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct CalendarTests {}

extension CalendarTests {
    @Test
    func generateDays() throws {
        // Given
        let dateInterval = DateInterval(
            start: Date(timeIntervalSince1970: 1617235200), // April 1, 2021 12:00:00 AM UTC
            end: Date(timeIntervalSince1970: 1619827200) // May 1, 2021 12:00:00 AM UTC
        )

        let utcCalendar: Calendar = .posix

        // When
        let utcDays = utcCalendar.generateDays(for: dateInterval)

        // Then
        #expect(utcDays.count == 30)
    }

    @Test
    func generateDaysWithLeapYear() throws {
        // Given
        let dateInterval = DateInterval(
            start: Date(timeIntervalSince1970: 1582761600), // February 27, 2020 12:00:00 AM
            end: Date(timeIntervalSince1970: 1583107200) // March 2, 2020 12:00:00 AM UTC
        )

        let utcCalendar: Calendar = .posix

        // When
        let utcDays = utcCalendar.generateDays(for: dateInterval)

        // Then
        #expect(utcDays.count == 4)
    }

    @Test
    func generateDaysWithoutLeapYear() throws {
        // Given
        let dateInterval = DateInterval(
            start: Date(timeIntervalSince1970: 1614384000), // February 27, 2021 12:00:00 AM UTC
            end: Date(timeIntervalSince1970: 1614643200) // March 2, 2021 12:00:00 AM UTC
        )

        let utcCalendar: Calendar = .posix

        // When
        let utcDays = utcCalendar.generateDays(for: dateInterval)

        // Then
        #expect(utcDays.count == 3)
    }
}

extension CalendarTests {
    @Test
    func generateWeek() throws {
        // Given
        let date = Date(timeIntervalSince1970: 1617285600) // April 1, 2021 2:00:00 PM UTC
        let utcCalendar: Calendar = .posix

        // When
        let week = utcCalendar.generateWeek(for: date)

        // Then
        #expect(week.count == 7)
        #expect(week.first == Date(timeIntervalSince1970: 1616889600))
        #expect(week.last == Date(timeIntervalSince1970: 1617408000))
    }

    @Test
    func generateWeekWithCustomFirstWeekday() throws {
        // Given
        let date = Date(timeIntervalSince1970: 1617285600) // April 1, 2021 2:00:00 PM UTC
        var utcCalendar: Calendar = .posix

        // When
        utcCalendar.firstWeekday = 3
        let week = utcCalendar.generateWeek(for: date)

        // Then
        #expect(week.count == 7)
        #expect(week.first == Date(timeIntervalSince1970: 1617062400))
        #expect(week.last == Date(timeIntervalSince1970: 1617580800))
    }
}
