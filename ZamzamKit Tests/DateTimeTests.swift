//
//  DateTimeHelperTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import ZamzamKit

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
    
    func testIsInCurrentWeek() {
        let date = Date()
        XCTAssert(date.isCurrentWeek)
        let dateOneYearFromNow = date + .weeks(1)
        XCTAssertFalse(dateOneYearFromNow.isCurrentWeek)
    }
    
    func testIsInCurrentMonth() {
        let date = Date()
        XCTAssert(date.isCurrentMonth)
        let dateOneYearFromNow = date + .months(1)
        XCTAssertFalse(dateOneYearFromNow.isCurrentMonth)
    }
    
    func testIsInCurrentYear() {
        let date = Date()
        XCTAssert(date.isCurrentYear)
        let dateOneYearFromNow = date + .years(1)
        XCTAssertFalse(dateOneYearFromNow.isCurrentYear)
    }
}

extension DateTimeTests {
    
    func testTomorrow() {
        let date = Date(fromString: "2016/03/22 09:30")!
        let expected = Date(fromString: "2016/03/23 09:30")!
        XCTAssertEqual(date.tomorrow, expected)
    }
    
    func testYesterday() {
        let date = Date(fromString: "2016/03/22 09:30")!
        let expected = Date(fromString: "2016/03/21 09:30")!
        XCTAssertEqual(date.yesterday, expected)
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
    
    func testDateToStringForCalendar() {
        let calendar = Calendar(identifier: .islamic)
        let date = Date(fromString: "1440/03/01 18:31", calendar: calendar)!
        XCTAssertEqual(date.string(format: "MMM d, h:mm a", calendar: calendar), "Rab. I 1, 6:31 PM")
    }
    
    func testDateToStringForCalendar2() {
        let calendar = Calendar(identifier: .hebrew)
        let date = Date(fromString: "5779/03/01 18:31", calendar: calendar)!
        XCTAssertEqual(date.string(format: "E, d MMMM yyyy", calendar: calendar), "Fri, 1 Kislev 5779")
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

// MARK: - Calculations

extension DateTimeTests {
    
    func testIncrementYears() {
        XCTAssertEqual(
            Date(fromString: "2018/11/01 00:00")! + .years(1),
            Date(fromString: "2019/11/01 00:00")
        )
        
        XCTAssertEqual(
            Date(fromString: "2018/11/01 00:00")! - .years(3),
            Date(fromString: "2015/11/01 00:00")
        )
        
        XCTAssertEqual(
            Date(fromString: "2015/10/26 18:31")! + .years(0),
            Date(fromString: "2015/10/26 18:31")!
        )
    }
    
    func testIncrementMonths() {
        XCTAssertEqual(
            Date(fromString: "2018/12/01 00:00")! + .months(1),
            Date(fromString: "2019/01/01 00:00")
        )
        
        XCTAssertEqual(
            Date(fromString: "2018/11/01 00:00")! - .months(3),
            Date(fromString: "2018/08/01 00:00")
        )
        
        XCTAssertEqual(
            Date(fromString: "2015/10/26 18:31")! + .months(0),
            Date(fromString: "2015/10/26 18:31")!
        )
    }
    
    func testIncrementDays() {
        XCTAssertEqual(
            Date(fromString: "2015/09/18 18:31")! + .days(1),
            Date(fromString: "2015/09/19 18:31")
        )
        
        XCTAssertEqual(
            Date(fromString: "2015/09/18 18:31")! - .days(1),
            Date(fromString: "2015/09/17 18:31")
        )
        
        XCTAssertEqual(
            Date(fromString: "2015/10/26 18:31")! + .days(0),
            Date(fromString: "2015/10/26 18:31")!
        )
        
        // Cross months
        XCTAssertEqual(
            Date(fromString: "1990/01/31 22:12")! + .days(2),
            Date(fromString: "1990/02/02 22:12")
        )
        
        // Leap year
        XCTAssertEqual(
            Date(fromString: "2016/02/20 13:12")! + .days(10),
            Date(fromString: "2016/03/01 13:12")
        )
    }
    
    func testIncrementWeeks() {
        XCTAssertEqual(
            Date(fromString: "2015/09/18 18:31")! + .weeks(1),
            Date(fromString: "2015/09/25 18:31")
        )
        
        XCTAssertEqual(
            Date(fromString: "2015/09/18 18:31")! - .weeks(1),
            Date(fromString: "2015/09/11 18:31")
        )
        XCTAssertEqual(
            Date(fromString: "2015/09/18 18:31")! + .weeks(4),
            Date(fromString: "2015/10/16 18:31")
        )
        
        XCTAssertEqual(
            Date(fromString: "2015/09/18 18:31")! - .weeks(4),
            Date(fromString: "2015/08/21 18:31")
        )
        
        XCTAssertEqual(
            Date(fromString: "2015/10/26 18:31")! + .weeks(0),
            Date(fromString: "2015/10/26 18:31")!
        )
        
        // Cross months
        XCTAssertEqual(
            Date(fromString: "1990/01/31 22:12")! + .weeks(4),
            Date(fromString: "1990/02/28 22:12")
        )
        
        // Leap year
        XCTAssertEqual(
            Date(fromString: "2016/02/20 13:12")! + .weeks(10),
            Date(fromString: "2016/04/30 13:12")
        )
    }
    
    func testIncrementHours() {
        XCTAssertEqual(
            Date(fromString: "2015/09/18 18:31")! + .hours(1),
            Date(fromString: "2015/09/18 19:31")
        )
        
        XCTAssertEqual(
            Date(fromString: "2015/09/18 18:31")! - .hours(1),
            Date(fromString: "2015/09/18 17:31")
        )
        
        // Overnight
        XCTAssertEqual(
            Date(fromString: "2015/12/14 23:04")! + .hours(1),
            Date(fromString: "2015/12/15 00:04")
        )
        
        XCTAssertEqual(
            Date(fromString: "2018/11/01 01:00")! - .hours(3),
            Date(fromString: "2018/10/31 22:00")
        )
        
        // New year
        XCTAssertEqual(
            Date(fromString: "2018/12/31 23:00")! + .hours(2),
            Date(fromString: "2019/01/01 01:00")
        )
        
        XCTAssertEqual(
            Date(fromString: "2017/01/01 02:00")! - .hours(3),
            Date(fromString: "2016/12/31 23:00")
        )
    }
    
    func testIncrementMinutes() {
        XCTAssertEqual(
            Date(fromString: "2015/09/18 18:31")! + .minutes(1),
            Date(fromString: "2015/09/18 18:32")
        )
        
        XCTAssertEqual(
            Date(fromString: "2015/09/18 18:31")! - .minutes(1),
            Date(fromString: "2015/09/18 18:30")
        )
        
        XCTAssertEqual(
            Date(fromString: "2015/12/14 07:04")! + .minutes(95),
            Date(fromString: "2015/12/14 08:39")
        )
        
        // Overnight
        XCTAssertEqual(
            Date(fromString: "2015/04/02 13:15")! + .minutes(1445),
            Date(fromString: "2015/04/03 13:20")
        )
        
        XCTAssertEqual(
            Date(fromString: "2015/12/14 23:04")! + .minutes(60),
            Date(fromString: "2015/12/15 00:04")
        )
        
        XCTAssertEqual(
            Date(fromString: "2018/11/01 01:00")! - .minutes(180),
            Date(fromString: "2018/10/31 22:00")
        )
        
        // New year
        XCTAssertEqual(
            Date(fromString: "2018/12/31 23:00")! + .minutes(120),
            Date(fromString: "2019/01/01 01:00")
        )
        
        XCTAssertEqual(
            Date(fromString: "2017/01/01 02:00")! - .minutes(180),
            Date(fromString: "2016/12/31 23:00")
        )
    }
    
    func testIncrementSeconds() {
        let format = "yyyy/MM/dd HH:mm:ss"
        
        XCTAssertEqual(
            Date(fromString: "2015/09/18 18:31:00", dateFormat: format)! + .seconds(1),
            Date(fromString: "2015/09/18 18:31:01", dateFormat: format)
        )
        
        XCTAssertEqual(
            Date(fromString: "2015/09/18 18:31:00", dateFormat: format)! - .seconds(1),
            Date(fromString: "2015/09/18 18:30:59", dateFormat: format)
        )
        
        // Overnight
        XCTAssertEqual(
            Date(fromString: "2015/12/14 23:59:59", dateFormat: format)! + .seconds(1),
            Date(fromString: "2015/12/15 00:00:00", dateFormat: format)
        )
        
        XCTAssertEqual(
            Date(fromString: "2018/11/01 00:00:00", dateFormat: format)! - .seconds(3),
            Date(fromString: "2018/10/31 23:59:57", dateFormat: format)
        )
        
        // New year
        XCTAssertEqual(
            Date(fromString: "2018/12/31 23:59:59", dateFormat: format)! + .seconds(2),
            Date(fromString: "2019/01/01 00:00:01", dateFormat: format)
        )
        
        XCTAssertEqual(
            Date(fromString: "2017/01/01 00:00:00", dateFormat: format)! - .seconds(3),
            Date(fromString: "2016/12/31 23:59:57", dateFormat: format)
        )
    }
    
    func testIncrementDaysWithCalendar() {
        let calendar = Calendar(identifier: .islamicUmmAlQura)
        
        XCTAssertEqual(
            Date(fromString: "1440/02/30 18:31", calendar: calendar)! + .days(1, calendar),
            Date(fromString: "1440/03/01 18:31", calendar: calendar)
        )
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
