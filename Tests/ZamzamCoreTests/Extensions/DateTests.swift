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
        let date = try XCTUnwrap(Date(fromString: "2016/03/22 09:30"))
        let expected = try XCTUnwrap(Date(fromString: "2016/03/23 09:30"))
        XCTAssertEqual(date.tomorrow, expected)
    }

    func testTomorrowLeapYear() throws {
        let date = try XCTUnwrap(Date(fromString: "2020/02/28 09:30"))
        let expected = try XCTUnwrap(Date(fromString: "2020/02/29 09:30"))
        XCTAssertEqual(date.tomorrow, expected)
    }

    func testTomorrowNonLeapYear() throws {
        let date = try XCTUnwrap(Date(fromString: "2021/02/28 09:30"))
        let expected = try XCTUnwrap(Date(fromString: "2021/03/01 09:30"))
        XCTAssertEqual(date.tomorrow, expected)
    }

    func testYesterday() throws {
        let date = try XCTUnwrap(Date(fromString: "2016/03/22 09:30"))
        let expected = try XCTUnwrap(Date(fromString: "2016/03/21 09:30"))
        XCTAssertEqual(date.yesterday, expected)
    }
}

extension DateTests {
    func testStartOfDay() throws {
        let date = try XCTUnwrap(Date(fromString: "2016/03/22 09:30"))
        XCTAssertEqual(date.startOfDay.string(format: "yyyy/MM/dd HH:mm:ss"), "2016/03/22 00:00:00")
    }

    func testEndOfDay() throws {
        let date = try XCTUnwrap(Date(fromString: "2018/01/21 19:30"))
        XCTAssertEqual(date.endOfDay.string(format: "yyyy/MM/dd HH:mm:ss"), "2018/01/21 23:59:59")
    }

    func testStartOfMonth() throws {
        let date = try XCTUnwrap(Date(fromString: "2016/03/22 09:30"))
        XCTAssertEqual(date.startOfMonth.string(format: "yyyy/MM/dd HH:mm:ss"), "2016/03/01 00:00:00")
    }

    func testEndOfMonth() throws {
        let date = try XCTUnwrap(Date(fromString: "2016/03/22 09:30"))
        XCTAssertEqual(date.endOfMonth.string(format: "yyyy/MM/dd HH:mm:ss"), "2016/03/31 23:59:59")
    }
}

// MARK: - Comparisons

extension DateTests {
    func testIsBetween() throws {
        XCTAssert(
            try XCTUnwrap(Date(fromString: "2020/01/15 09:30")).isBetween(
                try XCTUnwrap(Date(fromString: "2020/01/15 09:00")),
                try XCTUnwrap(Date(fromString: "2020/01/15 10:00"))
            )
        )

        XCTAssert(
            try XCTUnwrap(Date(fromString: "2020/01/16 01:00")).isBetween(
                try XCTUnwrap(Date(fromString: "2020/01/15 23:00")),
                try XCTUnwrap(Date(fromString: "2020/01/16 04:00"))
            )
        )

        XCTAssert(
            try XCTUnwrap(Date(fromString: "2020/01/15 10:00")).isBetween(
                try XCTUnwrap(Date(fromString: "2020/01/15 10:00")),
                try XCTUnwrap(Date(fromString: "2020/01/15 10:30"))
            )
        )

        XCTAssert(
            try XCTUnwrap(Date(fromString: "2020/01/15 10:00")).isBetween(
                try XCTUnwrap(Date(fromString: "2020/01/15 10:00")),
                try XCTUnwrap(Date(fromString: "2020/01/15 10:00"))
            )
        )

        XCTAssert(
            try XCTUnwrap(Date(fromString: "2020/01/15 09:00")).isBetween(
                try XCTUnwrap(Date(fromString: "2020/01/15 10:00")),
                try XCTUnwrap(Date(fromString: "2020/01/15 08:00"))
            )
        )

        XCTAssert(
            try XCTUnwrap(Date(fromString: "2020/01/15 08:00")).isBetween(
                try XCTUnwrap(Date(fromString: "2020/01/15 10:00")),
                try XCTUnwrap(Date(fromString: "2020/01/15 08:00"))
            )
        )

        XCTAssertFalse(
            try XCTUnwrap(Date(fromString: "2020/01/15 09:00")).isBetween(
                try XCTUnwrap(Date(fromString: "2020/01/15 10:00")),
                try XCTUnwrap(Date(fromString: "2020/01/15 13:00"))
            )
        )

        XCTAssertFalse(
            try XCTUnwrap(Date(fromString: "2020/01/15 10:30")).isBetween(
                try XCTUnwrap(Date(fromString: "2020/01/15 10:00")),
                try XCTUnwrap(Date(fromString: "2020/01/15 10:30"))
            )
        )

        XCTAssertFalse(
            try XCTUnwrap(Date(fromString: "2020/01/15 10:00")).isBetween(
                try XCTUnwrap(Date(fromString: "2020/01/15 10:00")),
                try XCTUnwrap(Date(fromString: "2020/01/15 08:00"))
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
        let date = try XCTUnwrap(Date(fromString: "2020/02/27 09:30", calendar: .posix))

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

        let date2 = try XCTUnwrap(Date(fromString: "2020/04/01 09:30", calendar: .posix))

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
    func testStringFromFormatter() throws {
        let formatter = DateFormatter(iso8601Format: "MM-dd-yyyy HH:mm:ss")
        let date = Date(timeIntervalSince1970: 1583697427)

        XCTAssertEqual(date.string(formatter: formatter), "03-08-2020 19:57:07")
    }

    func testStringToDate() throws {
        let date = try XCTUnwrap(Date(fromString: "1970/01/03 00:00"))
        let expected = Date(timeIntervalSince1970: TimeInterval(172800)
            - TimeInterval(TimeZone.current.secondsFromGMT())
            + TimeZone.current.daylightSavingTimeOffset())

        XCTAssertEqual(date, expected, "Date should be \(expected)")
    }

    func testDateToString() throws {
        let date = try XCTUnwrap(Date(fromString: "1970/01/03 20:43"))
        let expected = date.string(format: "MMM d, h:mm a")

        XCTAssertEqual("Jan 3, 8:43 PM", expected)
    }

    func testDateToStringForCalendar() throws {
        let calendar = Calendar(identifier: .islamic)
        let date = try XCTUnwrap(Date(fromString: "1440/03/01 18:31", calendar: calendar))
        XCTAssertEqual(date.string(format: "MMM d, h:mm a", calendar: calendar), "Rab. I 1, 6:31 PM")
    }

    func testDateToStringForCalendar2() throws {
        let calendar = Calendar(identifier: .hebrew)
        let date = try XCTUnwrap(Date(fromString: "5779/03/01 18:31", calendar: calendar))
        XCTAssertEqual(date.string(format: "E, d MMMM yyyy", calendar: calendar), "Fri, 1 Kislev 5779")
    }

    func testDateToTimer() throws {
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2016/03/22 09:45"))
                .timerString(from: try XCTUnwrap(Date(fromString: "2016/03/22 09:40"))),
            "00:05:00"
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2017/04/15 15:32"))
                .timerString(from: try XCTUnwrap(Date(fromString: "2017/04/15 15:39"))),
            "+00:07:00"
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2013/09/01 12:00:05", dateFormat: "yyyy/MM/dd HH:mm:ss"))
                .timerString(from: try XCTUnwrap(Date(fromString: "2013/09/01 12:00:00", dateFormat: "yyyy/MM/dd HH:mm:ss"))),
            "00:00:05"
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2017/04/15 15:30"))
                .timerString(from: try XCTUnwrap(Date(fromString: "2017/04/15 15:30"))),
            "00:00:00"
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2017/04/15 12:32:46", dateFormat: "yyyy/MM/dd HH:mm:ss"))
                .timerString(from: try XCTUnwrap(Date(fromString: "2016/09/29 20:12:03", dateFormat: "yyyy/MM/dd HH:mm:ss"))),
            "4,744:20:43"
        )
    }

    func testShortString() throws {
        let date = try XCTUnwrap(Date(fromString: "2017/05/14 13:32"))
        XCTAssertEqual("2017-05-14", date.shortString())
    }

    func testDayName() throws {
        let date = Date(timeIntervalSince1970: 1486121165)
        XCTAssertEqual(date.name(ofDay: .full), "Friday")
        XCTAssertEqual(date.name(ofDay: .threeLetters), "Fri")
        XCTAssertEqual(date.name(ofDay: .oneLetter), "F")
    }

    func testMonthName() throws {
        let date = Date(timeIntervalSince1970: 1486121165)
        XCTAssertEqual(date.name(ofMonth: .full), "February")
        XCTAssertEqual(date.name(ofMonth: .threeLetters), "Feb")
        XCTAssertEqual(date.name(ofMonth: .oneLetter), "F")
    }
}

// MARK: - Calculations

extension DateTests {
    func testIncrementYears() throws {
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2018/11/01 00:00")) + .years(1),
            Date(fromString: "2019/11/01 00:00")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2018/11/01 00:00")) - .years(3),
            Date(fromString: "2015/11/01 00:00")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/10/26 18:31")) + .years(0),
            try XCTUnwrap(Date(fromString: "2015/10/26 18:31"))
        )
    }

    func testIncrementMonths() throws {
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2018/12/01 00:00")) + .months(1),
            Date(fromString: "2019/01/01 00:00")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2018/11/01 00:00")) - .months(3),
            Date(fromString: "2018/08/01 00:00")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/10/26 18:31")) + .months(0),
            try XCTUnwrap(Date(fromString: "2015/10/26 18:31"))
        )
    }

    func testIncrementDays() throws {
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/09/18 18:31")) + .days(1),
            Date(fromString: "2015/09/19 18:31")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/09/18 18:31")) - .days(1),
            Date(fromString: "2015/09/17 18:31")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/10/26 18:31")) + .days(0),
            try XCTUnwrap(Date(fromString: "2015/10/26 18:31"))
        )

        // Cross months
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "1990/01/31 22:12")) + .days(2),
            Date(fromString: "1990/02/02 22:12")
        )

        // Leap year
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2016/02/20 13:12")) + .days(10),
            Date(fromString: "2016/03/01 13:12")
        )
    }

    func testIncrementWeeks() throws {
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/09/18 18:31")) + .weeks(1),
            Date(fromString: "2015/09/25 18:31")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/09/18 18:31")) - .weeks(1),
            Date(fromString: "2015/09/11 18:31")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/09/18 18:31")) + .weeks(4),
            Date(fromString: "2015/10/16 18:31")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/09/18 18:31")) - .weeks(4),
            Date(fromString: "2015/08/21 18:31")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/10/26 18:31")) + .weeks(0),
            try XCTUnwrap(Date(fromString: "2015/10/26 18:31"))
        )

        // Cross months
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "1990/01/31 22:12")) + .weeks(4),
            Date(fromString: "1990/02/28 22:12")
        )

        // Leap year
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2016/02/20 13:12")) + .weeks(10),
            Date(fromString: "2016/04/30 13:12")
        )
    }

    func testIncrementHours() throws {
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/09/18 18:31")) + .hours(1),
            Date(fromString: "2015/09/18 19:31")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/09/18 18:31")) - .hours(1),
            Date(fromString: "2015/09/18 17:31")
        )

        // Overnight
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/12/14 23:04")) + .hours(1),
            Date(fromString: "2015/12/15 00:04")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2018/11/01 01:00")) - .hours(3),
            Date(fromString: "2018/10/31 22:00")
        )

        // New year
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2018/12/31 23:00")) + .hours(2),
            Date(fromString: "2019/01/01 01:00")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2017/01/01 02:00")) - .hours(3),
            Date(fromString: "2016/12/31 23:00")
        )
    }

    func testIncrementMinutes() throws {
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/09/18 18:31")) + .minutes(1),
            Date(fromString: "2015/09/18 18:32")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/09/18 18:31")) - .minutes(1),
            Date(fromString: "2015/09/18 18:30")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/12/14 07:04")) + .minutes(95),
            Date(fromString: "2015/12/14 08:39")
        )

        // Overnight
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/04/02 13:15")) + .minutes(1445),
            Date(fromString: "2015/04/03 13:20")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/12/14 23:04")) + .minutes(60),
            Date(fromString: "2015/12/15 00:04")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2018/11/01 01:00")) - .minutes(180),
            Date(fromString: "2018/10/31 22:00")
        )

        // New year
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2018/12/31 23:00")) + .minutes(120),
            Date(fromString: "2019/01/01 01:00")
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2017/01/01 02:00")) - .minutes(180),
            Date(fromString: "2016/12/31 23:00")
        )
    }

    func testIncrementDaysWithCalendar() throws {
        let calendar = Calendar(identifier: .islamicUmmAlQura)

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "1440/02/30 18:31", calendar: calendar)) + .days(1, calendar),
            Date(fromString: "1440/03/01 18:31", calendar: calendar)
        )
    }

    func testIncrementDecrementShorthand() throws {
        var date1 = try XCTUnwrap(Date(fromString: "2018/12/31 23:00"))
        date1 += .minutes(120)
        XCTAssertEqual(date1, Date(fromString: "2019/01/01 01:00"))

        var date2 = try XCTUnwrap(Date(fromString: "2015/04/02 13:15"))
        date2 += .minutes(1445)
        XCTAssertEqual(date2, Date(fromString: "2015/04/03 13:20"))

        var date3 = try XCTUnwrap(Date(fromString: "2016/02/20 13:12"))
        date3 += .weeks(10)
        XCTAssertEqual(date3, Date(fromString: "2016/04/30 13:12"))

        var date4 = try XCTUnwrap(Date(fromString: "2015/10/26 18:31"))
        date4 += .days(0)
        XCTAssertEqual(date4, try XCTUnwrap(Date(fromString: "2015/10/26 18:31")))

        var date5 = try XCTUnwrap(Date(fromString: "1990/01/31 22:12"))
        date5 += .days(2)
        XCTAssertEqual(date5, Date(fromString: "1990/02/02 22:12"))

        var date6 = try XCTUnwrap(Date(fromString: "2015/09/18 18:31"))
        date6 -= .days(1)
        XCTAssertEqual(date6, Date(fromString: "2015/09/17 18:31"))

        var date7 = try XCTUnwrap(Date(fromString: "2018/11/01 00:00"))
        date7 -= .months(3)
        XCTAssertEqual(date7, Date(fromString: "2018/08/01 00:00"))

        var date8 = try XCTUnwrap(Date(fromString: "2018/11/01 00:00"))
        date8 -= .years(3)
        XCTAssertEqual(date8, Date(fromString: "2015/11/01 00:00"))

        var date9 = try XCTUnwrap(Date(fromString: "2015/10/26 18:31"))
        date9 += .years(0)
        XCTAssertEqual(date9, try XCTUnwrap(Date(fromString: "2015/10/26 18:31")))
    }
}

extension DateTests {
    func testCurrentTimeInDecimal() throws {
        let time = try XCTUnwrap(Date(fromString: "2012/10/23 18:15")).timeToDecimal
        let expectedTime = 18.25

        XCTAssertEqual(time, expectedTime)
    }
}

extension DateTests {
    func testHijriDate() throws {
        do {
            let gregorianDate = try XCTUnwrap(Date(fromString: "2015/09/23 12:30"))
            let hijriDate = gregorianDate.hijriString(template: "yyyyGMMMMd")
            let expectedDate = "Dhuʻl-Hijjah 10, 1436 AH"

            XCTAssertEqual("\(hijriDate)", expectedDate)
        }

        do {
            let gregorianDate = try XCTUnwrap(Date(fromString: "2017/06/26 00:00"))
            let hijriDate = gregorianDate.hijriString()
            let expectedDate = "Shawwal 2, 1438"

            XCTAssertEqual("\(hijriDate)", expectedDate)
        }
    }

    func testRamadan() throws {
        XCTAssert(try XCTUnwrap(Date(fromString: "2015/07/01 12:30")).isRamadan())
        XCTAssertFalse(try XCTUnwrap(Date(fromString: "2017/01/01 12:30")).isRamadan())
    }

    func testJumuah() throws {
        XCTAssert(try XCTUnwrap(Date(fromString: "2017/04/21 12:30")).isJumuah)
        XCTAssertFalse(try XCTUnwrap(Date(fromString: "2017/01/01 12:30")).isJumuah)
    }
}

extension DateTests {
    func testDateIntervalProgress() throws {
        let startDate = try XCTUnwrap(Date(fromString: "2021/04/21 12:30"))
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
