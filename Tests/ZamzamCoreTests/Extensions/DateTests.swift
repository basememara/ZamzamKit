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
            try XCTUnwrap(Date(fromString: "2018/06/15 09:30")).isBetween(
                try XCTUnwrap(Date(fromString: "2018/06/15 09:00")),
                try XCTUnwrap(Date(fromString: "2018/08/15 09:30"))
            )
        )

        XCTAssertFalse(
            try XCTUnwrap(Date(fromString: "2020/01/15 09:00")).isBetween(
                try XCTUnwrap(Date(fromString: "2020/01/15 10:00")),
                try XCTUnwrap(Date(fromString: "2020/01/15 13:00"))
            )
        )

        XCTAssert(
            try XCTUnwrap(Date(fromString: "2020/01/15 09:00")).isBetween(
                try XCTUnwrap(Date(fromString: "2020/01/15 10:00")),
                try XCTUnwrap(Date(fromString: "2018/01/15 13:00"))
            )
        )

        let date = Date()
        let date1 = Date(timeIntervalSinceNow: 1000)
        let date2 = Date(timeIntervalSinceNow: -1000)
        XCTAssert(date.isBetween(date1, date2))
    }

    func testIsBeyondSeconds() throws {
        let date = try XCTUnwrap(Date(fromString: "2016/03/22 09:40"))
        let fromDate = try XCTUnwrap(Date(fromString: "2016/03/22 09:30"))

        XCTAssert(date.isBeyond(fromDate, bySeconds: 300))
        XCTAssertFalse(date.isBeyond(fromDate, bySeconds: 600))
        XCTAssertFalse(date.isBeyond(fromDate, bySeconds: 1200))
    }

    func testIsBeyondMinutes() throws {
        let date = try XCTUnwrap(Date(fromString: "2016/03/22 09:40"))
        let fromDate = try XCTUnwrap(Date(fromString: "2016/03/22 09:30"))

        XCTAssert(date.isBeyond(fromDate, byMinutes: 5))
        XCTAssertFalse(date.isBeyond(fromDate, byMinutes: 10))
        XCTAssertFalse(date.isBeyond(fromDate, byMinutes: 25))
    }

    func testIsBeyondHours() throws {
        let date = try XCTUnwrap(Date(fromString: "2016/03/22 11:40"))
        let fromDate = try XCTUnwrap(Date(fromString: "2016/03/22 09:40"))

        XCTAssert(date.isBeyond(fromDate, byHours: 1))
        XCTAssertFalse(date.isBeyond(fromDate, byHours: 2))
        XCTAssertFalse(date.isBeyond(fromDate, byHours: 4))
    }

    func testIsBeyondDays() throws {
        let formatter = DateFormatter().apply {
            $0.dateFormat = "yyyy/MM/dd HH:mm"
        }

        let date = try XCTUnwrap(formatter.date(from: "2016/03/24 11:40"))
        let fromDate = try XCTUnwrap(formatter.date(from: "2016/03/22 09:40"))

        XCTAssert(date.isBeyond(fromDate, byDays: 1))
        XCTAssert(date.isBeyond(fromDate, byDays: 2))
        XCTAssertFalse(date.isBeyond(fromDate, byDays: 3))
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
        XCTAssertEqual(date.string(format: "MMM d, h:mm a", calendar: calendar), "Rab. I 1, 6:31 PM")
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

    func testIncrementSeconds() throws {
        let format = "yyyy/MM/dd HH:mm:ss"

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/09/18 18:31:00", dateFormat: format)) + .seconds(1),
            Date(fromString: "2015/09/18 18:31:01", dateFormat: format)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/09/18 18:31:00", dateFormat: format)) - .seconds(1),
            Date(fromString: "2015/09/18 18:30:59", dateFormat: format)
        )

        // Overnight
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2015/12/14 23:59:59", dateFormat: format)) + .seconds(1),
            Date(fromString: "2015/12/15 00:00:00", dateFormat: format)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2018/11/01 00:00:00", dateFormat: format)) - .seconds(3),
            Date(fromString: "2018/10/31 23:59:57", dateFormat: format)
        )

        // New year
        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2018/12/31 23:59:59", dateFormat: format)) + .seconds(2),
            Date(fromString: "2019/01/01 00:00:01", dateFormat: format)
        )

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "2017/01/01 00:00:00", dateFormat: format)) - .seconds(3),
            Date(fromString: "2016/12/31 23:59:57", dateFormat: format)
        )
    }

    func testIncrementDaysWithCalendar() throws {
        let calendar = Calendar(identifier: .islamicUmmAlQura)

        XCTAssertEqual(
            try XCTUnwrap(Date(fromString: "1440/02/30 18:31", calendar: calendar)) + .days(1, calendar),
            Date(fromString: "1440/03/01 18:31", calendar: calendar)
        )
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
            let hijriDate = gregorianDate.hijriString()
            let expectedDate = "Dhuʻl-Hijjah 10, 1436 AH"

            XCTAssertEqual("\(hijriDate)", expectedDate)
        }

        do {
            let gregorianDate = try XCTUnwrap(Date(fromString: "2017/06/26 00:00"))
            let hijriDate = gregorianDate.hijriString()
            let expectedDate = "Shawwal 2, 1438 AH"

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
