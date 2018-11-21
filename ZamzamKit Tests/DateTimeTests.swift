//
//  DateTimeHelperTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import ZamzamKit

class DateTimeTests: XCTestCase {
    
    func testIsPast() {
        XCTAssertTrue(Date(timeIntervalSinceNow: -100).isPast)
        XCTAssertFalse(Date(timeIntervalSinceNow: 100).isPast)
    }
    
    func testIsFuture() {
        XCTAssertTrue(Date(timeIntervalSinceNow: 100).isFuture)
        XCTAssertFalse(Date(timeIntervalSinceNow: -100).isFuture)
    }
    
    func testIsToday() {
        XCTAssertTrue(Date().isToday)
    }
    
    func testIsYesterday() {
        XCTAssertTrue(Date(timeIntervalSinceNow: -90_000).isYesterday)
    }
    
    func testIsTomorrow() {
        XCTAssertTrue(Date(timeIntervalSinceNow: 90_000).isTomorrow)
    }
    
    func testIsWeekday() {
        let date = Date()
        XCTAssertEqual(date.isWeekday, !Calendar.current.isDateInWeekend(date))
    }
	
	func testIsWeekend() {
		let date = Date()
		XCTAssertEqual(date.isWeekend, Calendar.current.isDateInWeekend(date))
	}
}

extension DateTimeTests {
    
    func testStartOfDay() {
        let date = Date(fromString: "2016/03/22 09:30")!
        XCTAssertEqual(date.startOfDay.string(format: "yyyy/MM/dd HH:mm:ss"), "2016/03/22 00:00:00")
    }
    
    func testEndOfDay() {
        let date = Date(fromString: "2018/01/31 19:30")!
        XCTAssertEqual(date.endOfDay.string(format: "yyyy/MM/dd HH:mm:ss"), "2018/01/31 23:59:59")
    }
    
    func testStartOfMonth() {
        let date = Date(fromString: "2016/03/22 09:30")!
        XCTAssertEqual(date.startOfMonth.string(format: "yyyy/MM/dd"), "2016/03/01")
    }
    
    func testEndOfMonth() {
        let date = Date(fromString: "2016/03/22 09:30")!
        XCTAssertEqual(date.endOfMonth.string(format: "yyyy/MM/dd"), "2016/03/31")
    }
}

// MARK: - Comparisons

extension DateTimeTests {
    
    func testIsBetween() {
        XCTAssertTrue(
            Date(fromString: "2018/06/15 09:30")!.isBetween(
                Date(fromString: "2018/06/15 09:00")!,
                Date(fromString: "2018/08/15 09:30")!
            )
        )
        
        XCTAssertFalse(
            Date(fromString: "2020/01/15 09:00")!.isBetween(
                Date(fromString: "2020/01/15 10:00")!,
                Date(fromString: "2020/01/15 13:00")!
            )
        )
        
        XCTAssertTrue(
            Date(fromString: "2020/01/15 09:00")!.isBetween(
                Date(fromString: "2020/01/15 10:00")!,
                Date(fromString: "2018/01/15 13:00")!
            )
        )
        
        let date = Date()
        let date1 = Date(timeIntervalSinceNow: 1000)
        let date2 = Date(timeIntervalSinceNow: -1000)
        XCTAssertTrue(date.isBetween(date1, date2))
    }
    
    func testIsBeyondSeconds() {
        let date = Date(fromString: "2016/03/22 09:40")!
        let fromDate = Date(fromString: "2016/03/22 09:30")!
        
        XCTAssertTrue(date.isBeyond(fromDate, bySeconds: 300))
        XCTAssertFalse(date.isBeyond(fromDate, bySeconds: 600))
        XCTAssertFalse(date.isBeyond(fromDate, bySeconds: 1200))
    }
    
    func testIsBeyondMinutes() {
        let date = Date(fromString: "2016/03/22 09:40")!
        let fromDate = Date(fromString: "2016/03/22 09:30")!
        
        XCTAssertTrue(date.isBeyond(fromDate, byMinutes: 5))
        XCTAssertFalse(date.isBeyond(fromDate, byMinutes: 10))
        XCTAssertFalse(date.isBeyond(fromDate, byMinutes: 25))
    }
    
    func testIsBeyondHours() {
        let date = Date(fromString: "2016/03/22 11:40")!
        let fromDate = Date(fromString: "2016/03/22 09:40")!
        
        XCTAssertTrue(date.isBeyond(fromDate, byHours: 1))
        XCTAssertFalse(date.isBeyond(fromDate, byHours: 2))
        XCTAssertFalse(date.isBeyond(fromDate, byHours: 4))
    }
}

// MARK: - String

extension DateTimeTests {
    
    func testStringToDate() {
        let date = Date(fromString: "1970/01/03 00:00")!
        let expected = Date(timeIntervalSince1970: TimeInterval(172800)
            - TimeInterval(TimeZone.current.secondsFromGMT())
            + TimeZone.current.daylightSavingTimeOffset())
        
        XCTAssertEqual(date, expected, "Date should be \(expected)")
    }
    
    func testDateToString() {
        let date = Date(fromString: "1970/01/03 20:43")!
        let expected = date.string(format: "MMM d, h:mm a")
        
        XCTAssertEqual("Jan 3, 8:43 PM", expected)
    }
    
    func testDateToTimer() {
        XCTAssertEqual(Date(fromString: "2016/03/22 09:45")!.timerString(
            from: Date(fromString: "2016/03/22 09:40")!), "00:05:00")
            
        XCTAssertEqual(Date(fromString: "2017/04/15 15:32")!.timerString(
            from: Date(fromString: "2017/04/15 15:39")!), "+00:07:00")
            
        XCTAssertEqual(Date(fromString: "2013/09/01 12:00:05", dateFormat: "yyyy/MM/dd HH:mm:ss")!.timerString(
            from: Date(fromString: "2013/09/01 12:00:00", dateFormat: "yyyy/MM/dd HH:mm:ss")!), "00:00:05")
            
        XCTAssertEqual(Date(fromString: "2017/04/15 15:30")!.timerString(
            from: Date(fromString: "2017/04/15 15:30")!), "00:00:00")
            
        XCTAssertEqual(Date(fromString: "2017/04/15 12:32:46", dateFormat: "yyyy/MM/dd HH:mm:ss")!.timerString(
            from: Date(fromString: "2016/09/29 20:12:03", dateFormat: "yyyy/MM/dd HH:mm:ss")!), "4,744:20:43")
    }
    
    func testShortString() {
        let date = Date(fromString: "2017/05/14 13:32")!
        XCTAssertEqual("2017-05-14", date.shortString())
    }
}

// MARK: - Increments

extension DateTimeTests {
    
    func testIncrementYear() {
        XCTAssertEqual(
            Date(fromString: "2018/11/01 00:00")!.increment(years: 1),
            Date(fromString: "2019/11/01 00:00")
        )
        
        XCTAssertEqual(
            Date(fromString: "2018/11/01 00:00")!.increment(years: -3),
            Date(fromString: "2015/11/01 00:00")
        )
    }
    
    func testIncrementMonth() {
        XCTAssertEqual(
            Date(fromString: "2018/12/01 00:00")!.increment(months: 1),
            Date(fromString: "2019/01/01 00:00")
        )
        
        XCTAssertEqual(
            Date(fromString: "2018/11/01 00:00")!.increment(months: -3),
            Date(fromString: "2018/08/01 00:00")
        )
    }
    
    func testIncrementToday() {
        let incrementedDate = Date().increment(days: 1)
        let calendar = Calendar(identifier: .gregorian)
        let tomorrow = calendar.date(
            byAdding: .day,
            value: 1,
            to: Date()
        )!
        
        XCTAssertEqual(
            calendar.startOfDay(for: incrementedDate),
            calendar.startOfDay(for: tomorrow)
        )
    }
    
    func testIncrementZeroDay() {
        let fromDate = Date(fromString: "2015/10/26 18:31")!
        let incrementedDate = fromDate.increment(days: 0)
        
        XCTAssertEqual(incrementedDate, fromDate)
    }
    
    func testIncrementOneDay() {
        let fromDate = Date(fromString: "2050/02/15 05:06")!
        let incrementedDate = fromDate.increment(days: 1)
        let expectedDate = Date(fromString: "2050/02/16 05:06")
        
        XCTAssertEqual(incrementedDate, expectedDate)
    }
    
    func testIncrementTwoDay() {
        let fromDate = Date(fromString: "1990/01/31 22:12")!
        let incrementedDate = fromDate.increment(days: 2)
        let expectedDate = Date(fromString: "1990/02/02 22:12")
        
        XCTAssertEqual(incrementedDate, expectedDate)
    }
    
    func testIncrementLeapYearDay() {
        let fromDate = Date(fromString: "2016/02/20 13:12")!
        let incrementedDate = fromDate.increment(days: 10)
        let expectedDate = Date(fromString: "2016/03/01 13:12")
        
        XCTAssertEqual(incrementedDate, expectedDate)
    }
    
    func testIncrementDayIfPast() {
        let fromDate = Date(fromString: "1999/01/15 10:15")!
        let incrementedDate = fromDate.incrementDayIfPast()
        let expectedDate = Date(fromString: "1999/01/16 10:15")
        
        XCTAssertEqual(incrementedDate, expectedDate)
    }
    
    func testIncrementDayIfPastForFuture() {
        let fromDate = Date(fromString: "2050/01/15 10:15")!
        let incrementedDate = fromDate.incrementDayIfPast()
        let expectedDate = Date(fromString: "2050/01/15 10:15")
        
        XCTAssertEqual(incrementedDate, expectedDate)
    }
    
    func testIncrementMinute() {
        let fromDate = Date(fromString: "2015/09/18 18:31")!
        let incrementedDate = fromDate.increment(minutes: 1)
        let expectedDate = Date(fromString: "2015/09/18 18:32")
        
        XCTAssertEqual(incrementedDate, expectedDate)
    }
    
    func testIncrementNintyFiveMinutes() {
        let fromDate = Date(fromString: "2015/12/14 07:04")!
        let incrementedDate = fromDate.increment(minutes: 95)
        let expectedDate = Date(fromString: "2015/12/14 08:39")
        
        XCTAssertEqual(incrementedDate, expectedDate)
    }
    
    func testIncrementDayByMinutes() {
        let fromDate = Date(fromString: "2015/04/02 13:15")!
        let incrementedDate = fromDate.increment(minutes: 1445)
        let expectedDate = Date(fromString: "2015/04/03 13:20")
        
        XCTAssertEqual(incrementedDate, expectedDate)
    }
}

extension DateTimeTests {
    
    func testCurrentTimeInDecimal() {
        let time = Date(fromString: "2012/10/23 18:15")!.timeToDecimal
        let expectedTime = 18.25
        
        XCTAssertEqual(time, expectedTime)
    }
}

extension DateTimeTests {
    
    func testHijriDate() {
        do {
            let gregorianDate = Date(fromString: "2015/09/23 12:30")!
            let hijriDate = gregorianDate.hijriString()
            let expectedDate = "Dhuʻl-Hijjah 10, 1436 AH"
            
            XCTAssertEqual("\(hijriDate)", expectedDate)
        }
        
        do {
            let gregorianDate = Date(fromString: "2017/06/26 00:00")!
            let hijriDate = gregorianDate.hijriString()
            let expectedDate = "Shawwal 2, 1438 AH"
            
            XCTAssertEqual("\(hijriDate)", expectedDate)
        }
    }
    
    func testRamadan() {
        XCTAssertTrue(Date(fromString: "2015/07/01 12:30")!.isRamadan())
        XCTAssertFalse(Date(fromString: "2017/01/01 12:30")!.isRamadan())
    }
    
    func testJumuah() {
        XCTAssertTrue(Date(fromString: "2017/04/21 12:30")!.isJumuah)
        XCTAssertFalse(Date(fromString: "2017/01/01 12:30")!.isJumuah)
    }
}
