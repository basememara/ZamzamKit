//
//  DateTimeHelperTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class DateTests: XCTestCase {}

extension DateTests {
    func testComponentsInitializer() {
        XCTAssertEqual(
            Date(year: 2022, month: 6, day: 2, hour: 14, minute: 54, second: 25, timeZone: .posix),
            Date(timeIntervalSince1970: 1654181665)
        )
    }

    func testComponentsInitializerTimeZone() {
        XCTAssertEqual(
            Date(year: 2022, month: 3, day: 6, hour: 2, minute: 1, second: 43, timeZone: TimeZone(abbreviation: "EST")),
            Date(timeIntervalSince1970: 1646550103)
        )
    }

    func testComponentsInitializerCalendar() {
        // Islamic calendar
        XCTAssertEqual(
            Date(year: 1443, month: 11, day: 3, hour: 17, minute: 42, second: 15, timeZone: .posix, calendar: Calendar(identifier: .islamicUmmAlQura)),
            Date(timeIntervalSince1970: 1654191735)
        )

        // Chinese calendar
        let gregorianYear = 2022
        let gregorianAdjustedToChinese = gregorianYear + 2697
        let chineseEra = Int(gregorianAdjustedToChinese / 60)
        let chineseYear = gregorianAdjustedToChinese - chineseEra * 60

        XCTAssertEqual(
            Date(era: chineseEra, year: chineseYear, month: 5, day: 5, hour: 0, minute: 18, second: 59, timeZone: TimeZone(abbreviation: "EST"), calendar: Calendar(identifier: .chinese)),
            Date(timeIntervalSince1970: 1654229939)
        )
    }
}

extension DateTests {
    func testIsPast() throws {
        XCTAssert(Date(timeIntervalSinceNow: -100).isPast)
        XCTAssertFalse(Date(timeIntervalSinceNow: 100).isPast)
    }

    func testIsFuture() throws {
        XCTAssert(Date(timeIntervalSinceNow: 100).isFuture)
        XCTAssertFalse(Date(timeIntervalSinceNow: -100).isFuture)
    }

    func testIsToday() throws {
        XCTAssert(Date().isToday)
    }

    func testIsYesterday() throws {
        XCTAssert(Date(timeIntervalSinceNow: -86_400).isYesterday)
    }

    func testIsTomorrow() throws {
        XCTAssert(Date(timeIntervalSinceNow: 86_400).isTomorrow)
    }

    func testIsWeekday() throws {
        let date = Date()
        XCTAssertEqual(date.isWeekday, !Calendar.current.isDateInWeekend(date))
    }

	func testIsWeekend() throws {
		let date = Date()
		XCTAssertEqual(date.isWeekend, Calendar.current.isDateInWeekend(date))
	}

    func testIsInCurrentWeek() throws {
        let date = Date()
        XCTAssert(date.isCurrentWeek)
        let dateOneYearFromNow = date + .weeks(1)
        XCTAssertFalse(dateOneYearFromNow.isCurrentWeek)
    }

    func testIsInCurrentMonth() throws {
        let date = Date()
        XCTAssert(date.isCurrentMonth)
        let dateOneYearFromNow = date + .months(1)
        XCTAssertFalse(dateOneYearFromNow.isCurrentMonth)
    }

    func testIsInCurrentYear() throws {
        let date = Date()
        XCTAssert(date.isCurrentYear)
        let dateOneYearFromNow = date + .years(1)
        XCTAssertFalse(dateOneYearFromNow.isCurrentYear)
    }
}

extension DateTests {
    func testTomorrow() throws {
        let date = try XCTUnwrap(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        let expected = try XCTUnwrap(Date(year: 2016, month: 3, day: 23, hour: 9, minute: 30))
        XCTAssertEqual(date.tomorrow, expected)
    }

    func testTomorrowLeapYear() throws {
        let date = try XCTUnwrap(Date(year: 2020, month: 2, day: 28, hour: 9, minute: 30))
        let expected = try XCTUnwrap(Date(year: 2020, month: 2, day: 29, hour: 9, minute: 30))
        XCTAssertEqual(date.tomorrow, expected)
    }

    func testTomorrowNonLeapYear() throws {
        let date = try XCTUnwrap(Date(year: 2021, month: 2, day: 28, hour: 9, minute: 30))
        let expected = try XCTUnwrap(Date(year: 2021, month: 3, day: 1, hour: 9, minute: 30))
        XCTAssertEqual(date.tomorrow, expected)
    }

    func testYesterday() throws {
        let date = try XCTUnwrap(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        let expected = try XCTUnwrap(Date(year: 2016, month: 3, day: 21, hour: 9, minute: 30))
        XCTAssertEqual(date.yesterday, expected)
    }
}

extension DateTests {
    func testStartOfDay() throws {
        let date = try XCTUnwrap(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        XCTAssertEqual(date.startOfDay.string(format: "yyyy/MM/dd HH:mm:ss"), "2016/03/22 00:00:00")
    }

    func testEndOfDay() throws {
        let date = try XCTUnwrap(Date(year: 2018, month: 1, day: 21, hour: 19, minute: 30))
        XCTAssertEqual(date.endOfDay.string(format: "yyyy/MM/dd HH:mm:ss"), "2018/01/21 23:59:59")
    }

    func testStartOfMonth() throws {
        let date = try XCTUnwrap(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        XCTAssertEqual(date.startOfMonth.string(format: "yyyy/MM/dd HH:mm:ss"), "2016/03/01 00:00:00")
    }

    func testEndOfMonth() throws {
        let date = try XCTUnwrap(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        XCTAssertEqual(date.endOfMonth.string(format: "yyyy/MM/dd HH:mm:ss"), "2016/03/31 23:59:59")
    }

    func testStartOfYear() throws {
        let date = try XCTUnwrap(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        XCTAssertEqual(date.startOfYear.string(format: "yyyy/MM/dd HH:mm:ss"), "2016/01/01 00:00:00")
    }

    func testEndOfYear() throws {
        let date = try XCTUnwrap(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        XCTAssertEqual(date.endOfYear.string(format: "yyyy/MM/dd HH:mm:ss"), "2016/12/31 23:59:59")
    }
}

// MARK: - Comparisons

extension DateTests {
    func testIsBetween() throws {
        XCTAssert(
            try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 9, minute: 30)).isBetween(
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 9)),
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10))
            )
        )

        XCTAssert(
            try XCTUnwrap(Date(year: 2020, month: 1, day: 16, hour: 1)).isBetween(
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 23)),
                try XCTUnwrap(Date(year: 2020, month: 1, day: 16, hour: 4))
            )
        )

        XCTAssert(
            try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10)).isBetween(
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10)),
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10, minute: 30))
            )
        )

        XCTAssert(
            try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10)).isBetween(
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10)),
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10))
            )
        )

        XCTAssert(
            try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 9)).isBetween(
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10)),
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 8))
            )
        )

        XCTAssert(
            try XCTUnwrap(Date(year: 2020, month: 1, day: 15, minute: 8)).isBetween(
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, minute: 10)),
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, minute: 8))
            )
        )

        XCTAssertFalse(
            try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 9)).isBetween(
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10)),
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 13))
            )
        )

        XCTAssertFalse(
            try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10, minute: 30)).isBetween(
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10)),
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10, minute: 30))
            )
        )

        XCTAssertFalse(
            try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10)).isBetween(
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 10)),
                try XCTUnwrap(Date(year: 2020, month: 1, day: 15, hour: 8))
            )
        )

        let date = Date()
        let date1 = Date(timeIntervalSinceNow: 1000)
        let date2 = Date(timeIntervalSinceNow: -1000)
        XCTAssert(date.isBetween(date1, date2))
    }
}

extension DateTests {
    func testExpanding() throws {
        let date = try XCTUnwrap(Date(year: 2020, month: 2, day: 27, hour: 9, minute: 30, calendar: .posix))

        XCTAssertEqual(
            date.expanding(to: .week, using: .posix),
            DateInterval(start: Date(timeIntervalSince1970: 1582416000), end: Date(timeIntervalSince1970: 1583020800))
        )

        XCTAssertEqual(
            date.expanding(to: .month, using: .posix),
            DateInterval(start: Date(timeIntervalSince1970: 1580515200), end: Date(timeIntervalSince1970: 1583020800))
        )

        XCTAssertEqual(
            date.expanding(to: .monthWithTrailingWeeks, using: .posix),
            DateInterval(start: Date(timeIntervalSince1970: 1579996800), end: Date(timeIntervalSince1970: 1583020800))
        )

        let date2 = try XCTUnwrap(Date(year: 2020, month: 4, day: 1, hour: 9, minute: 30, calendar: .posix))

        XCTAssertEqual(
            date2.expanding(to: .week, using: .posix),
            DateInterval(start: Date(timeIntervalSince1970: 1585440000), end: Date(timeIntervalSince1970: 1586044800))
        )

        XCTAssertEqual(
            date2.expanding(to: .month, using: .posix),
            DateInterval(start: Date(timeIntervalSince1970: 1585699200), end: Date(timeIntervalSince1970: 1588291200))
        )

        XCTAssertEqual(
            date2.expanding(to: .monthWithTrailingWeeks, using: .posix),
            DateInterval(start: Date(timeIntervalSince1970: 1585440000), end: Date(timeIntervalSince1970: 1588464000))
        )
    }
}

// MARK: - String

extension DateTests {
    func testShortString() throws {
        let date = try XCTUnwrap(Date(year: 2017, month: 5, day: 14, hour: 13, minute: 32))
        XCTAssertEqual("2017-05-14", date.shortString())
    }
}

// MARK: - Calculations

extension DateTests {
    func testIncrementYears() throws {
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2018, month: 11, day: 1)) + .years(1),
            Date(year: 2019, month: 11, day: 1)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2018, month: 11, day: 1)) - .years(3),
            Date(year: 2015, month: 11, day: 1)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31)) + .years(0),
            try XCTUnwrap(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))
        )
    }

    func testIncrementMonths() throws {
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2018, month: 12, day: 1)) + .months(1),
            Date(year: 2019, month: 1, day: 1)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2018, month: 11, day: 1)) - .months(3),
            Date(year: 2018, month: 8, day: 1)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31)) + .months(0),
            try XCTUnwrap(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))
        )
    }

    func testIncrementDays() throws {
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) + .days(1),
            Date(year: 2015, month: 09, day: 19, hour: 18, minute: 31)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) - .days(1),
            Date(year: 2015, month: 9, day: 17, hour: 18, minute: 31)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31)) + .days(0),
            try XCTUnwrap(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))
        )

        // Cross months
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 1990, month: 1, day: 31, hour: 22, minute: 12)) + .days(2),
            Date(year: 1990, month: 2, day: 2, hour: 22, minute: 12)
        )

        // Leap year
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2016, month: 2, day: 20, hour: 13, minute: 12)) + .days(10),
            Date(year: 2016, month: 3, day: 1, hour: 13, minute: 12)
        )
    }

    func testIncrementWeeks() throws {
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) + .weeks(1),
            Date(year: 2015, month: 9, day: 25, hour: 18, minute: 31)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) - .weeks(1),
            Date(year: 2015, month: 9, day: 11, hour: 18, minute: 31)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) + .weeks(4),
            Date(year: 2015, month: 10, day: 16, hour: 18, minute: 31)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) - .weeks(4),
            Date(year: 2015, month: 8, day: 21, hour: 18, minute: 31)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31)) + .weeks(0),
            try XCTUnwrap(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))
        )

        // Cross months
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 1990, month: 1, day: 31, hour: 22, minute: 12)) + .weeks(4),
            Date(year: 1990, month: 2, day: 28, hour: 22, minute: 12)
        )

        // Leap year
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2016, month: 2, day: 20, hour: 13, minute: 12)) + .weeks(10),
            Date(year: 2016, month: 4, day: 30, hour: 13, minute: 12)
        )
    }

    func testIncrementHours() throws {
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) + .hours(1),
            Date(year: 2015, month: 9, day: 18, hour: 19, minute: 31)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) - .hours(1),
            Date(year: 2015, month: 9, day: 18, hour: 17, minute: 31)
        )

        // Overnight
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 12, day: 14, hour: 23, minute: 4)) + .hours(1),
            Date(year: 2015, month: 12, day: 15, minute: 4)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2018, month: 11, day: 1, hour: 1)) - .hours(3),
            Date(year: 2018, month: 10, day: 31, hour: 22)
        )

        // New year
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2018, month: 12, day: 31, hour: 23)) + .hours(2),
            Date(year: 2019, month: 1, day: 1, hour: 1)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2017, month: 1, day: 1, hour: 2)) - .hours(3),
            Date(year: 2016, month: 12, day: 31, hour: 23)
        )
    }

    func testIncrementMinutes() throws {
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) + .minutes(1),
            Date(year: 2015, month: 9, day: 18, hour: 18, minute: 32)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) - .minutes(1),
            Date(year: 2015, month: 9, day: 18, hour: 18, minute: 30)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 12, day: 14, hour: 7, minute: 4)) + .minutes(95),
            Date(year: 2015, month: 12, day: 14, hour: 8, minute: 39)
        )

        // Overnight
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 4, day: 2, hour: 13, minute: 15)) + .minutes(1445),
            Date(year: 2015, month: 4, day: 3, hour: 13, minute: 20)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2015, month: 12, day: 14, hour: 23, minute: 4)) + .minutes(60),
            Date(year: 2015, month: 12, day: 15, hour: 0, minute: 4)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2018, month: 11, day: 1, hour: 1)) - .minutes(180),
            Date(year: 2018, month: 10, day: 31, hour: 22)
        )

        // New year
        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2018, month: 12, day: 31, hour: 23)) + .minutes(120),
            Date(year: 2019, month: 1, day: 1, hour: 1)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 2017, month: 1, day: 1, hour: 2)) - .minutes(180),
            Date(year: 2016, month: 12, day: 31, hour: 23)
        )
    }

    func testIncrementDaysWithCalendar() throws {
        let calendar = Calendar(identifier: .islamicUmmAlQura)

        XCTAssertEqual(
            try XCTUnwrap(Date(year: 1440, month: 2, day: 30, hour: 18, minute: 31, calendar: calendar)) + .days(1, calendar),
            Date(year: 1440, month: 3, day: 1, hour: 18, minute: 31, calendar: calendar)
        )
    }

    func testIncrementDecrementShorthand() throws {
        var date1 = try XCTUnwrap(Date(year: 2018, month: 12, day: 31, hour: 23))
        date1 += .minutes(120)
        XCTAssertEqual(date1, Date(year: 2019, month: 1, day: 1, hour: 1))

        var date2 = try XCTUnwrap(Date(year: 2015, month: 4, day: 2, hour: 13, minute: 15))
        date2 += .minutes(1445)
        XCTAssertEqual(date2, Date(year: 2015, month: 4, day: 3, hour: 13, minute: 20))

        var date3 = try XCTUnwrap(Date(year: 2016, month: 2, day: 20, hour: 13, minute: 12))
        date3 += .weeks(10)
        XCTAssertEqual(date3, Date(year: 2016, month: 4, day: 30, hour: 13, minute: 12))

        var date4 = try XCTUnwrap(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))
        date4 += .days(0)
        XCTAssertEqual(date4, try XCTUnwrap(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31)))

        var date5 = try XCTUnwrap(Date(year: 1990, month: 1, day: 31, hour: 22, minute: 12))
        date5 += .days(2)
        XCTAssertEqual(date5, Date(year: 1990, month: 2, day: 2, hour: 22, minute: 12))

        var date6 = try XCTUnwrap(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31))
        date6 -= .days(1)
        XCTAssertEqual(date6, Date(year: 2015, month: 9, day: 17, hour: 18, minute: 31))

        var date7 = try XCTUnwrap(Date(year: 2018, month: 11, day: 1))
        date7 -= .months(3)
        XCTAssertEqual(date7, Date(year: 2018, month: 8, day: 1))

        var date8 = try XCTUnwrap(Date(year: 2018, month: 11, day: 1))
        date8 -= .years(3)
        XCTAssertEqual(date8, Date(year: 2015, month: 11, day: 1))

        var date9 = try XCTUnwrap(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))
        date9 += .years(0)
        XCTAssertEqual(date9, try XCTUnwrap(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31)))
    }
}

extension DateTests {
    func testCurrentTimeInDecimal() throws {
        let time = try XCTUnwrap(Date(year: 2012, month: 10, day: 23, hour: 18, minute: 15)).timeToDecimal
        let expectedTime = 18.25

        XCTAssertEqual(time, expectedTime)
    }
}

extension DateTests {
    func testHijriDate() throws {
        do {
            let gregorianDate = try XCTUnwrap(Date(year: 2015, month: 9, day: 23, hour: 12, minute: 30))
            let hijriDate = gregorianDate.hijriString(template: "yyyyGMMMMd")
            let expectedDate = "Dhuʻl-Hijjah 10, 1436 AH"

            XCTAssertEqual("\(hijriDate)", expectedDate)
        }

        do {
            let gregorianDate = try XCTUnwrap(Date(year: 2017, month: 6, day: 26))
            let hijriDate = gregorianDate.hijriString()
            let expectedDate = "Shawwal 2, 1438"

            XCTAssertEqual("\(hijriDate)", expectedDate)
        }
    }

    func testRamadan() throws {
        XCTAssert(try XCTUnwrap(Date(year: 2015, month: 7, day: 1, hour: 12, minute: 30)).isRamadan())
        XCTAssertFalse(try XCTUnwrap(Date(year: 2017, month: 1, day: 1, hour: 12, minute: 30)).isRamadan())
    }

    func testJumuah() throws {
        XCTAssert(try XCTUnwrap(Date(year: 2017, month: 4, day: 21, hour: 12, minute: 30)).isJumuah)
        XCTAssertFalse(try XCTUnwrap(Date(year: 2017, month: 1, day: 1, hour: 12, minute: 30)).isJumuah)
    }
}

extension DateTests {
    func testDateIntervalProgress() throws {
        let startDate = try XCTUnwrap(Date(year: 2021, month: 4, day: 21, hour: 12, minute: 30))
        let interval1 = DateInterval(start: startDate, duration: 0)
        let interval2 = DateInterval(start: startDate, duration: 500)

        let progress1 = interval1.progress(at: startDate)
        XCTAssertEqual(progress1.remaining, 0)
        XCTAssertEqual(progress1.value, 1)

        let progress2 = interval2.progress(at: startDate)
        XCTAssertEqual(progress2.remaining, 500)
        XCTAssertEqual(progress2.value, 1)

        let progress3 = interval2.progress(at: startDate + 200)
        XCTAssertEqual(progress3.remaining, 300)
        XCTAssertEqual(progress3.value, 0.6)

        let progress4 = interval2.progress(at: startDate + 250)
        XCTAssertEqual(progress4.remaining, 250)
        XCTAssertEqual(progress4.value, 0.5)

        let progress5 = interval2.progress(at: startDate + 600)
        XCTAssertEqual(progress5.remaining, 0)
        XCTAssertEqual(progress5.value, 1)

        let progress6 = interval2.progress(at: startDate - 1000)
        XCTAssertEqual(progress6.remaining, 1500)
        XCTAssertEqual(progress6.value, 0)

        let progress7 = interval1.progress(at: startDate - 100)
        XCTAssertEqual(progress7.remaining, 100)
        XCTAssertEqual(progress7.value, 0)

        let progress8 = interval1.progress(at: startDate + 100)
        XCTAssertEqual(progress8.remaining, 0)
        XCTAssertEqual(progress8.value, 1)
    }
}

extension DateTests {
    func testDateIntervalStride() throws {
        let startDate = Date(timeIntervalSince1970: 1626386307)

        let interval1 = DateInterval(start: startDate, duration: 125)
        let dates1 = interval1.stride(by: 15)
        XCTAssertEqual(dates1.count, 9)
        XCTAssertEqual(dates1[0].timeIntervalSince1970, 1626386307)
        XCTAssertEqual(dates1[1].timeIntervalSince1970, 1626386307 + 15)
        XCTAssertEqual(dates1[2].timeIntervalSince1970, 1626386307 + 15 * 2)
        XCTAssertEqual(dates1[3].timeIntervalSince1970, 1626386307 + 15 * 3)
        XCTAssertEqual(dates1[4].timeIntervalSince1970, 1626386307 + 15 * 4)
        XCTAssertEqual(dates1[5].timeIntervalSince1970, 1626386307 + 15 * 5)
        XCTAssertEqual(dates1[6].timeIntervalSince1970, 1626386307 + 15 * 6)
        XCTAssertEqual(dates1[7].timeIntervalSince1970, 1626386307 + 15 * 7)
        XCTAssertEqual(dates1[8].timeIntervalSince1970, 1626386307 + 15 * 8)

        let interval2 = DateInterval(start: startDate, duration: 0)
        let dates2 = interval2.stride(by: 15)
        XCTAssertEqual(dates2.count, 1)
        XCTAssertEqual(dates2[0].timeIntervalSince1970, 1626386307)

        let interval3 = DateInterval(start: startDate, duration: 600)
        let dates3 = interval3.stride(by: 60)
        XCTAssertEqual(dates3.count, 11)
        XCTAssertEqual(dates3[0].timeIntervalSince1970, 1626386307)
        XCTAssertEqual(dates3[1].timeIntervalSince1970, 1626386307 + 60)
        XCTAssertEqual(dates3[2].timeIntervalSince1970, 1626386307 + 60 * 2)
        XCTAssertEqual(dates3[3].timeIntervalSince1970, 1626386307 + 60 * 3)
        XCTAssertEqual(dates3[4].timeIntervalSince1970, 1626386307 + 60 * 4)
        XCTAssertEqual(dates3[5].timeIntervalSince1970, 1626386307 + 60 * 5)
        XCTAssertEqual(dates3[6].timeIntervalSince1970, 1626386307 + 60 * 6)
        XCTAssertEqual(dates3[7].timeIntervalSince1970, 1626386307 + 60 * 7)
        XCTAssertEqual(dates3[8].timeIntervalSince1970, 1626386307 + 60 * 8)
        XCTAssertEqual(dates3[9].timeIntervalSince1970, 1626386307 + 60 * 9)
    }
}

// MARK: - Helpers

private extension Date {
    func string(format: String, timeZone: TimeZone? = nil, calendar: Calendar? = nil, locale: Locale? = nil) -> String {
        DateFormatter(dateFormat: format, timeZone: timeZone, calendar: calendar, locale: locale).string(from: self)
    }
}
