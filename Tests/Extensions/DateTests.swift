//
//  DateTimeHelperTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct DateTests {}

extension DateTests {
    @Test
    func componentsInitializer() {
        #expect(Date(year: 2022, month: 6, day: 2, hour: 14, minute: 54, second: 25, timeZone: .posix) == Date(timeIntervalSince1970: 1654181665))
    }

    @Test
    func componentsInitializerTimeZone() {
        #expect(Date(year: 2022, month: 3, day: 6, hour: 2, minute: 1, second: 43, timeZone: TimeZone(abbreviation: "EST")) == Date(timeIntervalSince1970: 1646550103))
    }

    @Test
    func componentsInitializerCalendar() {
        // Islamic calendar
        #expect(Date(year: 1443, month: 11, day: 3, hour: 17, minute: 42, second: 15, timeZone: .posix, calendar: Calendar(identifier: .islamicUmmAlQura)) == Date(timeIntervalSince1970: 1654191735))

        // Chinese calendar
        let gregorianYear = 2022
        let gregorianAdjustedToChinese = gregorianYear + 2697
        let chineseEra = Int(gregorianAdjustedToChinese / 60)
        let chineseYear = gregorianAdjustedToChinese - chineseEra * 60

        #expect(Date(era: chineseEra, year: chineseYear, month: 5, day: 5, hour: 0, minute: 18, second: 59, timeZone: TimeZone(abbreviation: "EST"), calendar: Calendar(identifier: .chinese)) == Date(timeIntervalSince1970: 1654229939))
    }
}

extension DateTests {
    @Test
    func isPast() throws {
        #expect(Date(timeIntervalSinceNow: -100).isPast)
        #expect(!(Date(timeIntervalSinceNow: 100).isPast))
    }

    @Test
    func isFuture() throws {
        #expect(Date(timeIntervalSinceNow: 100).isFuture)
        #expect(!(Date(timeIntervalSinceNow: -100).isFuture))
    }

    @Test
    func isToday() throws {
        #expect(Date().isToday)
    }

    @Test
    func isYesterday() throws {
        #expect(Date(timeIntervalSinceNow: -86_400).isYesterday)
    }

    @Test
    func isTomorrow() throws {
        #expect(Date(timeIntervalSinceNow: 86_400).isTomorrow)
    }

    @Test
    func isWeekday() throws {
        let date = Date()
        #expect(date.isWeekday == !Calendar.current.isDateInWeekend(date))
    }

	@Test
	func isWeekend() throws {
		let date = Date()
		#expect(date.isWeekend == Calendar.current.isDateInWeekend(date))
	}

    @Test
    func isInCurrentWeek() throws {
        let date = Date()
        #expect(date.isCurrentWeek)
        let dateOneYearFromNow = date + .weeks(1)
        #expect(!(dateOneYearFromNow.isCurrentWeek))
    }

    @Test
    func isInCurrentMonth() throws {
        let date = Date()
        #expect(date.isCurrentMonth)
        let dateOneYearFromNow = date + .months(1)
        #expect(!(dateOneYearFromNow.isCurrentMonth))
    }

    @Test
    func isInCurrentYear() throws {
        let date = Date()
        #expect(date.isCurrentYear)
        let dateOneYearFromNow = date + .years(1)
        #expect(!(dateOneYearFromNow.isCurrentYear))
    }
}

extension DateTests {
    @Test
    func tomorrow() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        let expected = try #require(Date(year: 2016, month: 3, day: 23, hour: 9, minute: 30))
        #expect(date.tomorrow == expected)
    }

    @Test
    func tomorrowLeapYear() throws {
        let date = try #require(Date(year: 2020, month: 2, day: 28, hour: 9, minute: 30))
        let expected = try #require(Date(year: 2020, month: 2, day: 29, hour: 9, minute: 30))
        #expect(date.tomorrow == expected)
    }

    @Test
    func tomorrowNonLeapYear() throws {
        let date = try #require(Date(year: 2021, month: 2, day: 28, hour: 9, minute: 30))
        let expected = try #require(Date(year: 2021, month: 3, day: 1, hour: 9, minute: 30))
        #expect(date.tomorrow == expected)
    }

    @Test
    func yesterday() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        let expected = try #require(Date(year: 2016, month: 3, day: 21, hour: 9, minute: 30))
        #expect(date.yesterday == expected)
    }
}

extension DateTests {
    @Test
    func startOfDay() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        #expect(date.startOfDay.string(format: "yyyy/MM/dd HH:mm:ss") == "2016/03/22 00:00:00")
    }

    @Test
    func endOfDay() throws {
        let date = try #require(Date(year: 2018, month: 1, day: 21, hour: 19, minute: 30))
        #expect(date.endOfDay.string(format: "yyyy/MM/dd HH:mm:ss") == "2018/01/21 23:59:59")
    }

    @Test
    func startOfMonth() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        #expect(date.startOfMonth.string(format: "yyyy/MM/dd HH:mm:ss") == "2016/03/01 00:00:00")
    }

    @Test
    func endOfMonth() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        #expect(date.endOfMonth.string(format: "yyyy/MM/dd HH:mm:ss") == "2016/03/31 23:59:59")
    }

    @Test
    func startOfYear() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        #expect(date.startOfYear.string(format: "yyyy/MM/dd HH:mm:ss") == "2016/01/01 00:00:00")
    }

    @Test
    func endOfYear() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30))
        #expect(date.endOfYear.string(format: "yyyy/MM/dd HH:mm:ss") == "2016/12/31 23:59:59")
    }
}

// MARK: - Comparisons

extension DateTests {
    @Test
    func isBetween() throws {
        #expect(try #require(Date(year: 2020, month: 1, day: 15, hour: 9, minute: 30)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 9)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10))
            ))

        #expect(try #require(Date(year: 2020, month: 1, day: 16, hour: 1)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 23)),
                try #require(Date(year: 2020, month: 1, day: 16, hour: 4))
            ))

        #expect(try #require(Date(year: 2020, month: 1, day: 15, hour: 10)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10, minute: 30))
            ))

        #expect(try #require(Date(year: 2020, month: 1, day: 15, hour: 10)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10))
            ))

        #expect(try #require(Date(year: 2020, month: 1, day: 15, hour: 9)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 8))
            ))

        #expect(try #require(Date(year: 2020, month: 1, day: 15, minute: 8)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, minute: 10)),
                try #require(Date(year: 2020, month: 1, day: 15, minute: 8))
            ))

        #expect(!(try #require(Date(year: 2020, month: 1, day: 15, hour: 9)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 13))
            )))

        #expect(!(try #require(Date(year: 2020, month: 1, day: 15, hour: 10, minute: 30)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10, minute: 30))
            )))

        #expect(!(try #require(Date(year: 2020, month: 1, day: 15, hour: 10)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 8))
            )))

        let date = Date()
        let date1 = Date(timeIntervalSinceNow: 1000)
        let date2 = Date(timeIntervalSinceNow: -1000)
        #expect(date.isBetween(date1, date2))
    }
}

extension DateTests {
    @Test
    func expanding() throws {
        let date = try #require(Date(year: 2020, month: 2, day: 27, hour: 9, minute: 30, calendar: .posix))

        #expect(date.expanding(to: .week, using: .posix) == DateInterval(start: Date(timeIntervalSince1970: 1582416000), end: Date(timeIntervalSince1970: 1583020800)))

        #expect(date.expanding(to: .month, using: .posix) == DateInterval(start: Date(timeIntervalSince1970: 1580515200), end: Date(timeIntervalSince1970: 1583020800)))

        #expect(date.expanding(to: .monthWithTrailingWeeks, using: .posix) == DateInterval(start: Date(timeIntervalSince1970: 1579996800), end: Date(timeIntervalSince1970: 1583020800)))

        let date2 = try #require(Date(year: 2020, month: 4, day: 1, hour: 9, minute: 30, calendar: .posix))

        #expect(date2.expanding(to: .week, using: .posix) == DateInterval(start: Date(timeIntervalSince1970: 1585440000), end: Date(timeIntervalSince1970: 1586044800)))

        #expect(date2.expanding(to: .month, using: .posix) == DateInterval(start: Date(timeIntervalSince1970: 1585699200), end: Date(timeIntervalSince1970: 1588291200)))

        #expect(date2.expanding(to: .monthWithTrailingWeeks, using: .posix) == DateInterval(start: Date(timeIntervalSince1970: 1585440000), end: Date(timeIntervalSince1970: 1588464000)))
    }
}

// MARK: - String

extension DateTests {
    @Test
    func shortString() throws {
        let date = try #require(Date(year: 2017, month: 5, day: 14, hour: 13, minute: 32))
        #expect("2017-05-14" == date.shortString())
    }
}

// MARK: - Calculations

extension DateTests {
    @Test
    func incrementYears() throws {
        #expect(try #require(Date(year: 2018, month: 11, day: 1)) + .years(1) == Date(year: 2019, month: 11, day: 1))

        #expect(try #require(Date(year: 2018, month: 11, day: 1)) - .years(3) == Date(year: 2015, month: 11, day: 1))

        let expected = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))

        #expect(try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31)) + .years(0) == expected)
    }

    @Test
    func incrementMonths() throws {
        #expect(try #require(Date(year: 2018, month: 12, day: 1)) + .months(1) == Date(year: 2019, month: 1, day: 1))

        #expect(try #require(Date(year: 2018, month: 11, day: 1)) - .months(3) == Date(year: 2018, month: 8, day: 1))

        let expected = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))

        #expect(try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31)) + .months(0) == expected)
    }

    @Test
    func incrementDays() throws {
        #expect(try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) + .days(1) == Date(year: 2015, month: 09, day: 19, hour: 18, minute: 31))

        #expect(try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) - .days(1) == Date(year: 2015, month: 9, day: 17, hour: 18, minute: 31))

        let expected = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))

        #expect(try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31)) + .days(0) == expected)

        // Cross months
        #expect(try #require(Date(year: 1990, month: 1, day: 31, hour: 22, minute: 12)) + .days(2) == Date(year: 1990, month: 2, day: 2, hour: 22, minute: 12))

        // Leap year
        #expect(try #require(Date(year: 2016, month: 2, day: 20, hour: 13, minute: 12)) + .days(10) == Date(year: 2016, month: 3, day: 1, hour: 13, minute: 12))
    }

    @Test
    func incrementWeeks() throws {
        #expect(try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) + .weeks(1) == Date(year: 2015, month: 9, day: 25, hour: 18, minute: 31))

        #expect(try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) - .weeks(1) == Date(year: 2015, month: 9, day: 11, hour: 18, minute: 31))

        #expect(try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) + .weeks(4) == Date(year: 2015, month: 10, day: 16, hour: 18, minute: 31))

        #expect(try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) - .weeks(4) == Date(year: 2015, month: 8, day: 21, hour: 18, minute: 31))

        let expected = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))

        #expect(try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31)) + .weeks(0) == expected)

        // Cross months
        #expect(try #require(Date(year: 1990, month: 1, day: 31, hour: 22, minute: 12)) + .weeks(4) == Date(year: 1990, month: 2, day: 28, hour: 22, minute: 12))

        // Leap year
        #expect(try #require(Date(year: 2016, month: 2, day: 20, hour: 13, minute: 12)) + .weeks(10) == Date(year: 2016, month: 4, day: 30, hour: 13, minute: 12))
    }

    @Test
    func incrementHours() throws {
        #expect(try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) + .hours(1) == Date(year: 2015, month: 9, day: 18, hour: 19, minute: 31))

        #expect(try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) - .hours(1) == Date(year: 2015, month: 9, day: 18, hour: 17, minute: 31))

        // Overnight
        #expect(try #require(Date(year: 2015, month: 12, day: 14, hour: 23, minute: 4)) + .hours(1) == Date(year: 2015, month: 12, day: 15, minute: 4))

        #expect(try #require(Date(year: 2018, month: 11, day: 1, hour: 1)) - .hours(3) == Date(year: 2018, month: 10, day: 31, hour: 22))

        // New year
        #expect(try #require(Date(year: 2018, month: 12, day: 31, hour: 23)) + .hours(2) == Date(year: 2019, month: 1, day: 1, hour: 1))

        #expect(try #require(Date(year: 2017, month: 1, day: 1, hour: 2)) - .hours(3) == Date(year: 2016, month: 12, day: 31, hour: 23))
    }

    @Test
    func incrementMinutes() throws {
        #expect(try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) + .minutes(1) == Date(year: 2015, month: 9, day: 18, hour: 18, minute: 32))

        #expect(try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31)) - .minutes(1) == Date(year: 2015, month: 9, day: 18, hour: 18, minute: 30))

        #expect(try #require(Date(year: 2015, month: 12, day: 14, hour: 7, minute: 4)) + .minutes(95) == Date(year: 2015, month: 12, day: 14, hour: 8, minute: 39))

        // Overnight
        #expect(try #require(Date(year: 2015, month: 4, day: 2, hour: 13, minute: 15)) + .minutes(1445) == Date(year: 2015, month: 4, day: 3, hour: 13, minute: 20))

        #expect(try #require(Date(year: 2015, month: 12, day: 14, hour: 23, minute: 4)) + .minutes(60) == Date(year: 2015, month: 12, day: 15, hour: 0, minute: 4))

        #expect(try #require(Date(year: 2018, month: 11, day: 1, hour: 1)) - .minutes(180) == Date(year: 2018, month: 10, day: 31, hour: 22))

        // New year
        #expect(try #require(Date(year: 2018, month: 12, day: 31, hour: 23)) + .minutes(120) == Date(year: 2019, month: 1, day: 1, hour: 1))

        #expect(try #require(Date(year: 2017, month: 1, day: 1, hour: 2)) - .minutes(180) == Date(year: 2016, month: 12, day: 31, hour: 23))
    }

    @Test
    func incrementDaysWithCalendar() throws {
        let calendar = Calendar(identifier: .islamicUmmAlQura)

        #expect(try #require(Date(year: 1440, month: 2, day: 30, hour: 18, minute: 31, calendar: calendar)) + .days(1, calendar) == Date(year: 1440, month: 3, day: 1, hour: 18, minute: 31, calendar: calendar))
    }

    @Test
    func incrementDecrementShorthand() throws {
        var date1 = try #require(Date(year: 2018, month: 12, day: 31, hour: 23))
        date1 += .minutes(120)
        #expect(date1 == Date(year: 2019, month: 1, day: 1, hour: 1))

        var date2 = try #require(Date(year: 2015, month: 4, day: 2, hour: 13, minute: 15))
        date2 += .minutes(1445)
        #expect(date2 == Date(year: 2015, month: 4, day: 3, hour: 13, minute: 20))

        var date3 = try #require(Date(year: 2016, month: 2, day: 20, hour: 13, minute: 12))
        date3 += .weeks(10)
        #expect(date3 == Date(year: 2016, month: 4, day: 30, hour: 13, minute: 12))

        var date4 = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))
        date4 += .days(0)
        let date4Expected = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))
        #expect(date4 == date4Expected)

        var date5 = try #require(Date(year: 1990, month: 1, day: 31, hour: 22, minute: 12))
        date5 += .days(2)
        #expect(date5 == Date(year: 1990, month: 2, day: 2, hour: 22, minute: 12))

        var date6 = try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31))
        date6 -= .days(1)
        #expect(date6 == Date(year: 2015, month: 9, day: 17, hour: 18, minute: 31))

        var date7 = try #require(Date(year: 2018, month: 11, day: 1))
        date7 -= .months(3)
        #expect(date7 == Date(year: 2018, month: 8, day: 1))

        var date8 = try #require(Date(year: 2018, month: 11, day: 1))
        date8 -= .years(3)
        #expect(date8 == Date(year: 2015, month: 11, day: 1))

        var date9 = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))
        date9 += .years(0)
        let date9Expected = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31))
        #expect(date9 == date9Expected)
    }
}

extension DateTests {
    @Test
    func currentTimeInDecimal() throws {
        let time = try #require(Date(year: 2012, month: 10, day: 23, hour: 18, minute: 15)).timeToDecimal
        let expectedTime = 18.25

        #expect(time == expectedTime)
    }
}

extension DateTests {
    @Test
    func hijriDate() throws {
        do {
            let gregorianDate = try #require(Date(year: 2015, month: 9, day: 23, hour: 12, minute: 30))
            let hijriDate = gregorianDate.hijriString(template: "yyyyGMMMMd")
            let expectedDate = "Dhuʻl-Hijjah 10, 1436 AH"

            #expect("\(hijriDate)" == expectedDate)
        }

        do {
            let gregorianDate = try #require(Date(year: 2017, month: 6, day: 26))
            let hijriDate = gregorianDate.hijriString()
            let expectedDate = "Shawwal 2, 1438"

            #expect("\(hijriDate)" == expectedDate)
        }
    }

    @Test
    func ramadan() throws {
        #expect(try #require(Date(year: 2015, month: 7, day: 1, hour: 12, minute: 30)).isRamadan())
        #expect(!(try #require(Date(year: 2017, month: 1, day: 1, hour: 12, minute: 30)).isRamadan()))
    }

    @Test
    func jumuah() throws {
        #expect(try #require(Date(year: 2017, month: 4, day: 21, hour: 12, minute: 30)).isJumuah)
        #expect(!(try #require(Date(year: 2017, month: 1, day: 1, hour: 12, minute: 30)).isJumuah))
    }

    @Test
    func eid() throws {
        #expect(try #require(Date(year: 2022, month: 7, day: 9, hour: 12, minute: 30)).isEid())
        #expect(try #require(Date(year: 2022, month: 7, day: 12, hour: 12, minute: 30)).isEid())
        #expect(try #require(Date(year: 2022, month: 5, day: 2, hour: 12, minute: 30)).isEid())
        #expect(try #require(Date(year: 2022, month: 5, day: 4, hour: 12, minute: 30)).isEid())
        #expect(!(try #require(Date(year: 2022, month: 7, day: 13, hour: 12, minute: 30)).isEid()))
        #expect(!(try #require(Date(year: 2022, month: 5, day: 5, hour: 12, minute: 30)).isEid()))
        #expect(!(try #require(Date(year: 2017, month: 1, day: 1, hour: 12, minute: 30)).isEid()))
    }
}

extension DateTests {
    @Test
    func dateIntervalProgress() throws {
        let date = Date.now
        let interval = DateInterval(start: date, duration: 100)

        let result1 = interval.progress(at: date + 20)
        #expect(result1.value == 0.2)
        #expect(result1.remaining == 80)

        let result2 = interval.progress(at: date + 50)
        #expect(result2.value == 0.5)
        #expect(result2.remaining == 50)

        let result3 = interval.progress(at: date + 75)
        #expect(result3.value == 0.75)
        #expect(result3.remaining == 25)

        let result4 = interval.progress(at: date + 99)
        #expect(result4.value == 0.99)
        #expect(result4.remaining == 1)

        let result5 = interval.progress(at: date + 350)
        #expect(result5.value == 1)
        #expect(result5.remaining == 0)

        let result6 = interval.progress(at: date - 350)
        #expect(result6.value == 0)
        #expect(result6.remaining == 450)
    }
}

extension DateTests {
    @Test
    func dateIntervalStride() throws {
        let startDate = Date(timeIntervalSince1970: 1626386307)

        let interval1 = DateInterval(start: startDate, duration: 125)
        let dates1 = interval1.stride(by: 15)
        #expect(dates1.count == 9)
        #expect(dates1[0].timeIntervalSince1970 == 1626386307)
        #expect(dates1[1].timeIntervalSince1970 == 1626386307 + 15)
        #expect(dates1[2].timeIntervalSince1970 == 1626386307 + 15 * 2)
        #expect(dates1[3].timeIntervalSince1970 == 1626386307 + 15 * 3)
        #expect(dates1[4].timeIntervalSince1970 == 1626386307 + 15 * 4)
        #expect(dates1[5].timeIntervalSince1970 == 1626386307 + 15 * 5)
        #expect(dates1[6].timeIntervalSince1970 == 1626386307 + 15 * 6)
        #expect(dates1[7].timeIntervalSince1970 == 1626386307 + 15 * 7)
        #expect(dates1[8].timeIntervalSince1970 == 1626386307 + 15 * 8)

        let interval2 = DateInterval(start: startDate, duration: 0)
        let dates2 = interval2.stride(by: 15)
        #expect(dates2.count == 1)
        #expect(dates2[0].timeIntervalSince1970 == 1626386307)

        let interval3 = DateInterval(start: startDate, duration: 600)
        let dates3 = interval3.stride(by: 60)
        #expect(dates3.count == 11)
        #expect(dates3[0].timeIntervalSince1970 == 1626386307)
        #expect(dates3[1].timeIntervalSince1970 == 1626386307 + 60)
        #expect(dates3[2].timeIntervalSince1970 == 1626386307 + 60 * 2)
        #expect(dates3[3].timeIntervalSince1970 == 1626386307 + 60 * 3)
        #expect(dates3[4].timeIntervalSince1970 == 1626386307 + 60 * 4)
        #expect(dates3[5].timeIntervalSince1970 == 1626386307 + 60 * 5)
        #expect(dates3[6].timeIntervalSince1970 == 1626386307 + 60 * 6)
        #expect(dates3[7].timeIntervalSince1970 == 1626386307 + 60 * 7)
        #expect(dates3[8].timeIntervalSince1970 == 1626386307 + 60 * 8)
        #expect(dates3[9].timeIntervalSince1970 == 1626386307 + 60 * 9)
    }
}

// MARK: - Helpers

private extension Date {
    func string(format: String, timeZone: TimeZone? = nil, calendar: Calendar? = nil, locale: Locale? = nil) -> String {
        DateFormatter(dateFormat: format, timeZone: timeZone, calendar: calendar, locale: locale).string(from: self)
    }
}
