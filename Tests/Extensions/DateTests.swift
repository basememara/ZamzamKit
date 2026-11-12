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

struct DateTests {
    private let calendar: Calendar = .posix
}

extension DateTests {
    @Test
    func componentsInitializer() {
        #expect(Date(year: 2022, month: 6, day: 2, hour: 14, minute: 54, second: 25, calendar: calendar) == Date(timeIntervalSince1970: 1654181665))
    }

    @Test
    func componentsInitializerTimeZone() throws {
        let eastern = Calendar(identifier: .gregorian, timeZone: try #require(TimeZone(abbreviation: "EST")))
        #expect(Date(year: 2022, month: 3, day: 6, hour: 2, minute: 1, second: 43, calendar: eastern) == Date(timeIntervalSince1970: 1646550103))
    }

    @Test
    func componentsInitializerCalendar() throws {
        // Islamic calendar
        #expect(Date(year: 1443, month: 11, day: 3, hour: 17, minute: 42, second: 15, calendar: Calendar(identifier: .islamicUmmAlQura, timeZone: .gmt)) == Date(timeIntervalSince1970: 1654191735))

        // Chinese calendar
        let gregorianYear = 2022
        let gregorianAdjustedToChinese = gregorianYear + 2697
        let chineseEra = Int(gregorianAdjustedToChinese / 60)
        let chineseYear = gregorianAdjustedToChinese - chineseEra * 60

        let date = Date(
            era: chineseEra,
            year: chineseYear,
            month: 5,
            day: 5,
            hour: 0,
            minute: 18,
            second: 59,
            calendar: Calendar(identifier: .chinese, timeZone: try #require(TimeZone(abbreviation: "EST")))
        )
        #expect(date == Date(timeIntervalSince1970: 1654229939))
    }
}

extension DateTests {
    @Test
    func tomorrow() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30, calendar: calendar))
        let expected = try #require(Date(year: 2016, month: 3, day: 23, hour: 9, minute: 30, calendar: calendar))
        #expect(date.tomorrow(using: calendar) == expected)
    }

    @Test
    func tomorrowLeapYear() throws {
        let date = try #require(Date(year: 2020, month: 2, day: 28, hour: 9, minute: 30, calendar: calendar))
        let expected = try #require(Date(year: 2020, month: 2, day: 29, hour: 9, minute: 30, calendar: calendar))
        #expect(date.tomorrow(using: calendar) == expected)
    }

    @Test
    func tomorrowNonLeapYear() throws {
        let date = try #require(Date(year: 2021, month: 2, day: 28, hour: 9, minute: 30, calendar: calendar))
        let expected = try #require(Date(year: 2021, month: 3, day: 1, hour: 9, minute: 30, calendar: calendar))
        #expect(date.tomorrow(using: calendar) == expected)
    }

    @Test
    func yesterday() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30, calendar: calendar))
        let expected = try #require(Date(year: 2016, month: 3, day: 21, hour: 9, minute: 30, calendar: calendar))
        #expect(date.yesterday(using: calendar) == expected)
    }
}

extension DateTests {
    @Test
    func startOfDay() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30, calendar: calendar))
        #expect(date.startOfDay(using: calendar).string(format: "yyyy/MM/dd HH:mm:ss", calendar: calendar) == "2016/03/22 00:00:00")
    }

    @Test
    func endOfDay() throws {
        let date = try #require(Date(year: 2018, month: 1, day: 21, hour: 19, minute: 30, calendar: calendar))
        #expect(date.endOfDay(using: calendar).string(format: "yyyy/MM/dd HH:mm:ss", calendar: calendar) == "2018/01/21 23:59:59")
    }

    @Test
    func startOfMonth() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30, calendar: calendar))
        #expect(date.startOfMonth(using: calendar).string(format: "yyyy/MM/dd HH:mm:ss", calendar: calendar) == "2016/03/01 00:00:00")
    }

    @Test
    func endOfMonth() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30, calendar: calendar))
        #expect(date.endOfMonth(using: calendar).string(format: "yyyy/MM/dd HH:mm:ss", calendar: calendar) == "2016/03/31 23:59:59")
    }

    @Test
    func startOfYear() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30, calendar: calendar))
        #expect(date.startOfYear(using: calendar).string(format: "yyyy/MM/dd HH:mm:ss", calendar: calendar) == "2016/01/01 00:00:00")
    }

    @Test
    func endOfYear() throws {
        let date = try #require(Date(year: 2016, month: 3, day: 22, hour: 9, minute: 30, calendar: calendar))
        #expect(date.endOfYear(using: calendar).string(format: "yyyy/MM/dd HH:mm:ss", calendar: calendar) == "2016/12/31 23:59:59")
    }
}

// MARK: - Comparisons

extension DateTests {
    @Test
    func isBetween() throws {
        #expect(try #require(Date(year: 2020, month: 1, day: 15, hour: 9, minute: 30, calendar: calendar)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 9, calendar: calendar)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10, calendar: calendar))
            ))

        #expect(try #require(Date(year: 2020, month: 1, day: 16, hour: 1, calendar: calendar)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 23, calendar: calendar)),
                try #require(Date(year: 2020, month: 1, day: 16, hour: 4, calendar: calendar))
            ))

        #expect(try #require(Date(year: 2020, month: 1, day: 15, hour: 10, calendar: calendar)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10, calendar: calendar)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10, minute: 30, calendar: calendar))
            ))

        #expect(try #require(Date(year: 2020, month: 1, day: 15, hour: 10, calendar: calendar)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10, calendar: calendar)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10, calendar: calendar))
            ))

        #expect(try #require(Date(year: 2020, month: 1, day: 15, hour: 9, calendar: calendar)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10, calendar: calendar)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 8, calendar: calendar))
            ))

        #expect(try #require(Date(year: 2020, month: 1, day: 15, minute: 8, calendar: calendar)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, minute: 10, calendar: calendar)),
                try #require(Date(year: 2020, month: 1, day: 15, minute: 8, calendar: calendar))
            ))

        #expect(!(try #require(Date(year: 2020, month: 1, day: 15, hour: 9, calendar: calendar)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10, calendar: calendar)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 13, calendar: calendar))
            )))

        #expect(!(try #require(Date(year: 2020, month: 1, day: 15, hour: 10, minute: 30, calendar: calendar)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10, calendar: calendar)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10, minute: 30, calendar: calendar))
            )))

        #expect(!(try #require(Date(year: 2020, month: 1, day: 15, hour: 10, calendar: calendar)).isBetween(
                try #require(Date(year: 2020, month: 1, day: 15, hour: 10, calendar: calendar)),
                try #require(Date(year: 2020, month: 1, day: 15, hour: 8, calendar: calendar))
            )))

        let date = Date(timeIntervalSince1970: 1_579_080_600)
        #expect(date.isBetween(date + 1000, date - 1000))
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
        let date = try #require(Date(year: 2017, month: 5, day: 14, hour: 13, minute: 32, calendar: calendar))
        #expect("2017-05-14" == date.shortString(calendar: calendar))
        #expect("2017-05-14" == date.shortString(calendar: Calendar(identifier: .gregorian, timeZone: .gmt)))
    }
}

// MARK: - Calculations

extension DateTests {
    @Test
    func incrementYears() throws {
        #expect(try #require(Date(year: 2018, month: 11, day: 1, calendar: calendar)) + .years(1, calendar) == Date(year: 2019, month: 11, day: 1, calendar: calendar))

        #expect(try #require(Date(year: 2018, month: 11, day: 1, calendar: calendar)) - .years(3, calendar) == Date(year: 2015, month: 11, day: 1, calendar: calendar))

        let expected = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31, calendar: calendar))

        #expect(try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31, calendar: calendar)) + .years(0, calendar) == expected)
    }

    @Test
    func incrementMonths() throws {
        #expect(try #require(Date(year: 2018, month: 12, day: 1, calendar: calendar)) + .months(1, calendar) == Date(year: 2019, month: 1, day: 1, calendar: calendar))

        #expect(try #require(Date(year: 2018, month: 11, day: 1, calendar: calendar)) - .months(3, calendar) == Date(year: 2018, month: 8, day: 1, calendar: calendar))

        let expected = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31, calendar: calendar))

        #expect(try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31, calendar: calendar)) + .months(0, calendar) == expected)
    }

    @Test
    func incrementDays() throws {
        #expect(
            try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31, calendar: calendar)) + .days(1, calendar)
                == Date(year: 2015, month: 09, day: 19, hour: 18, minute: 31, calendar: calendar)
        )

        #expect(
            try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31, calendar: calendar)) - .days(1, calendar)
                == Date(year: 2015, month: 9, day: 17, hour: 18, minute: 31, calendar: calendar)
        )

        let expected = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31, calendar: calendar))

        #expect(try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31, calendar: calendar)) + .days(0, calendar) == expected)

        // Cross months
        #expect(
            try #require(Date(year: 1990, month: 1, day: 31, hour: 22, minute: 12, calendar: calendar)) + .days(2, calendar)
                == Date(year: 1990, month: 2, day: 2, hour: 22, minute: 12, calendar: calendar)
        )

        // Leap year
        #expect(
            try #require(Date(year: 2016, month: 2, day: 20, hour: 13, minute: 12, calendar: calendar)) + .days(10, calendar)
                == Date(year: 2016, month: 3, day: 1, hour: 13, minute: 12, calendar: calendar)
        )
    }

    @Test
    func incrementWeeks() throws {
        #expect(
            try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31, calendar: calendar)) + .weeks(1, calendar)
                == Date(year: 2015, month: 9, day: 25, hour: 18, minute: 31, calendar: calendar)
        )

        #expect(
            try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31, calendar: calendar)) - .weeks(1, calendar)
                == Date(year: 2015, month: 9, day: 11, hour: 18, minute: 31, calendar: calendar)
        )

        #expect(
            try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31, calendar: calendar)) + .weeks(4, calendar)
                == Date(year: 2015, month: 10, day: 16, hour: 18, minute: 31, calendar: calendar)
        )

        #expect(
            try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31, calendar: calendar)) - .weeks(4, calendar)
                == Date(year: 2015, month: 8, day: 21, hour: 18, minute: 31, calendar: calendar)
        )

        let expected = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31, calendar: calendar))

        #expect(try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31, calendar: calendar)) + .weeks(0, calendar) == expected)

        // Cross months
        #expect(
            try #require(Date(year: 1990, month: 1, day: 31, hour: 22, minute: 12, calendar: calendar)) + .weeks(4, calendar)
                == Date(year: 1990, month: 2, day: 28, hour: 22, minute: 12, calendar: calendar)
        )

        // Leap year
        #expect(
            try #require(Date(year: 2016, month: 2, day: 20, hour: 13, minute: 12, calendar: calendar)) + .weeks(10, calendar)
                == Date(year: 2016, month: 4, day: 30, hour: 13, minute: 12, calendar: calendar)
        )
    }

    @Test
    func incrementHours() throws {
        #expect(
            try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31, calendar: calendar)) + .hours(1)
                == Date(year: 2015, month: 9, day: 18, hour: 19, minute: 31, calendar: calendar)
        )

        #expect(
            try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31, calendar: calendar)) - .hours(1)
                == Date(year: 2015, month: 9, day: 18, hour: 17, minute: 31, calendar: calendar)
        )

        // Overnight
        #expect(try #require(Date(year: 2015, month: 12, day: 14, hour: 23, minute: 4, calendar: calendar)) + .hours(1) == Date(year: 2015, month: 12, day: 15, minute: 4, calendar: calendar))

        #expect(try #require(Date(year: 2018, month: 11, day: 1, hour: 1, calendar: calendar)) - .hours(3) == Date(year: 2018, month: 10, day: 31, hour: 22, calendar: calendar))

        // New year
        #expect(try #require(Date(year: 2018, month: 12, day: 31, hour: 23, calendar: calendar)) + .hours(2) == Date(year: 2019, month: 1, day: 1, hour: 1, calendar: calendar))

        #expect(try #require(Date(year: 2017, month: 1, day: 1, hour: 2, calendar: calendar)) - .hours(3) == Date(year: 2016, month: 12, day: 31, hour: 23, calendar: calendar))
    }

    @Test
    func incrementMinutes() throws {
        #expect(
            try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31, calendar: calendar)) + .minutes(1)
                == Date(year: 2015, month: 9, day: 18, hour: 18, minute: 32, calendar: calendar)
        )

        #expect(
            try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31, calendar: calendar)) - .minutes(1)
                == Date(year: 2015, month: 9, day: 18, hour: 18, minute: 30, calendar: calendar)
        )

        #expect(
            try #require(Date(year: 2015, month: 12, day: 14, hour: 7, minute: 4, calendar: calendar)) + .minutes(95)
                == Date(year: 2015, month: 12, day: 14, hour: 8, minute: 39, calendar: calendar)
        )

        // Overnight
        #expect(
            try #require(Date(year: 2015, month: 4, day: 2, hour: 13, minute: 15, calendar: calendar)) + .minutes(1445)
                == Date(year: 2015, month: 4, day: 3, hour: 13, minute: 20, calendar: calendar)
        )

        #expect(
            try #require(Date(year: 2015, month: 12, day: 14, hour: 23, minute: 4, calendar: calendar)) + .minutes(60)
                == Date(year: 2015, month: 12, day: 15, hour: 0, minute: 4, calendar: calendar)
        )

        #expect(try #require(Date(year: 2018, month: 11, day: 1, hour: 1, calendar: calendar)) - .minutes(180) == Date(year: 2018, month: 10, day: 31, hour: 22, calendar: calendar))

        // New year
        #expect(try #require(Date(year: 2018, month: 12, day: 31, hour: 23, calendar: calendar)) + .minutes(120) == Date(year: 2019, month: 1, day: 1, hour: 1, calendar: calendar))

        #expect(try #require(Date(year: 2017, month: 1, day: 1, hour: 2, calendar: calendar)) - .minutes(180) == Date(year: 2016, month: 12, day: 31, hour: 23, calendar: calendar))
    }

    @Test
    func incrementDaysWithCalendar() throws {
        let calendar = Calendar(identifier: .islamicUmmAlQura, timeZone: .gmt)

        let date = try #require(Date(year: 1440, month: 2, day: 30, hour: 18, minute: 31, calendar: calendar))
        #expect(date + .days(1, calendar) == Date(year: 1440, month: 3, day: 1, hour: 18, minute: 31, calendar: calendar))
    }

    @Test
    func incrementDecrementShorthand() throws {
        var date1 = try #require(Date(year: 2018, month: 12, day: 31, hour: 23, calendar: calendar))
        date1 += .minutes(120)
        #expect(date1 == Date(year: 2019, month: 1, day: 1, hour: 1, calendar: calendar))

        var date2 = try #require(Date(year: 2015, month: 4, day: 2, hour: 13, minute: 15, calendar: calendar))
        date2 += .minutes(1445)
        #expect(date2 == Date(year: 2015, month: 4, day: 3, hour: 13, minute: 20, calendar: calendar))

        var date3 = try #require(Date(year: 2016, month: 2, day: 20, hour: 13, minute: 12, calendar: calendar))
        date3 += .weeks(10, calendar)
        #expect(date3 == Date(year: 2016, month: 4, day: 30, hour: 13, minute: 12, calendar: calendar))

        var date4 = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31, calendar: calendar))
        date4 += .days(0, calendar)
        let date4Expected = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31, calendar: calendar))
        #expect(date4 == date4Expected)

        var date5 = try #require(Date(year: 1990, month: 1, day: 31, hour: 22, minute: 12, calendar: calendar))
        date5 += .days(2, calendar)
        #expect(date5 == Date(year: 1990, month: 2, day: 2, hour: 22, minute: 12, calendar: calendar))

        var date6 = try #require(Date(year: 2015, month: 9, day: 18, hour: 18, minute: 31, calendar: calendar))
        date6 -= .days(1, calendar)
        #expect(date6 == Date(year: 2015, month: 9, day: 17, hour: 18, minute: 31, calendar: calendar))

        var date7 = try #require(Date(year: 2018, month: 11, day: 1, calendar: calendar))
        date7 -= .months(3, calendar)
        #expect(date7 == Date(year: 2018, month: 8, day: 1, calendar: calendar))

        var date8 = try #require(Date(year: 2018, month: 11, day: 1, calendar: calendar))
        date8 -= .years(3, calendar)
        #expect(date8 == Date(year: 2015, month: 11, day: 1, calendar: calendar))

        var date9 = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31, calendar: calendar))
        date9 += .years(0, calendar)
        let date9Expected = try #require(Date(year: 2015, month: 10, day: 26, hour: 18, minute: 31, calendar: calendar))
        #expect(date9 == date9Expected)
    }
}

extension DateTests {
    @Test
    func currentTimeInDecimal() throws {
        let time = try #require(Date(year: 2012, month: 10, day: 23, hour: 18, minute: 15, calendar: calendar)).timeToDecimal(using: calendar)
        let expectedTime = 18.25

        #expect(time == expectedTime)
    }
}

extension DateTests {
    @Test
    func hijriDate() throws {
        let english = Locale(identifier: "en_US")

        do {
            let gregorianDate = try #require(Date(year: 2015, month: 9, day: 23, hour: 12, minute: 30, calendar: calendar))
            let hijriDate = gregorianDate.hijriString(template: "yyyyGMMMMd", timeZone: calendar.timeZone, locale: english)
            let expectedDate = "Dhuʻl-Hijjah 10, 1436 AH"

            #expect("\(hijriDate)" == expectedDate)
        }

        do {
            let gregorianDate = try #require(Date(year: 2017, month: 6, day: 26, calendar: calendar))
            let hijriDate = gregorianDate.hijriString(timeZone: calendar.timeZone, locale: english)
            let expectedDate = "Shawwal 2, 1438"

            #expect("\(hijriDate)" == expectedDate)
        }
    }

    @Test
    func ramadan() throws {
        #expect(try #require(Date(year: 2015, month: 7, day: 1, hour: 12, minute: 30, calendar: calendar)).isRamadan(timeZone: calendar.timeZone))
        #expect(!(try #require(Date(year: 2017, month: 1, day: 1, hour: 12, minute: 30, calendar: calendar)).isRamadan(timeZone: calendar.timeZone)))
    }

    @Test
    func jumuah() throws {
        #expect(try #require(Date(year: 2017, month: 4, day: 21, hour: 12, minute: 30, calendar: calendar)).isJumuah(using: calendar))
        #expect(!(try #require(Date(year: 2017, month: 1, day: 1, hour: 12, minute: 30, calendar: calendar)).isJumuah(using: calendar)))
    }

    @Test
    func eid() throws {
        #expect(try #require(Date(year: 2022, month: 7, day: 9, hour: 12, minute: 30, calendar: calendar)).isEid(timeZone: calendar.timeZone))
        #expect(try #require(Date(year: 2022, month: 7, day: 12, hour: 12, minute: 30, calendar: calendar)).isEid(timeZone: calendar.timeZone))
        #expect(try #require(Date(year: 2022, month: 5, day: 2, hour: 12, minute: 30, calendar: calendar)).isEid(timeZone: calendar.timeZone))
        #expect(try #require(Date(year: 2022, month: 5, day: 4, hour: 12, minute: 30, calendar: calendar)).isEid(timeZone: calendar.timeZone))
        #expect(!(try #require(Date(year: 2022, month: 7, day: 13, hour: 12, minute: 30, calendar: calendar)).isEid(timeZone: calendar.timeZone)))
        #expect(!(try #require(Date(year: 2022, month: 5, day: 5, hour: 12, minute: 30, calendar: calendar)).isEid(timeZone: calendar.timeZone)))
        #expect(!(try #require(Date(year: 2017, month: 1, day: 1, hour: 12, minute: 30, calendar: calendar)).isEid(timeZone: calendar.timeZone)))
    }

    @Test
    func hijriComponentsAreReadInTheTimeZoneGiven() throws {
        // 11 PM UTC on 10 Dhuʻl-Hijjah 1443, already the next morning in Auckland
        let date = try #require(Date(year: 2022, month: 7, day: 9, hour: 23, calendar: calendar))
        let auckland = try #require(TimeZone(identifier: "Pacific/Auckland"))

        #expect(date.hijri(timeZone: .gmt).day == 10)
        #expect(date.hijri(timeZone: auckland).day == 11)
        #expect(date.hijri(offset: 1, timeZone: .gmt).day == 11)
        #expect(date.isEid(timeZone: .gmt))
        #expect(date.isEid(offset: 3, timeZone: auckland) == false)
    }
}

extension DateTests {
    @Test
    func dateIntervalProgress() throws {
        let date = Date(timeIntervalSince1970: 1_626_386_307)
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
