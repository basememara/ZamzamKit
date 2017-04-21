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
	
	func testIsWeekend() {
		let date = Date()
		XCTAssertEqual(date.isWeekend, Calendar.current.isDateInWeekend(date))
	}
    
    func testIsWeekday() {
        let date = Date()
        XCTAssertEqual(date.isWeekday, !Calendar.current.isDateInWeekend(date))
    }
    
    func testCurrentTimeInDecimal() {
        let time = Date(fromString: "2012/10/23 18:15")!.timeToDecimal
        let expectedTime = 18.25
        
        XCTAssertEqual(time, expectedTime,
            "Time should be \(expectedTime)")
    }
    
    func testHasElapsed() {
        let date = Date(fromString: "2016/03/22 09:30")!
        
        XCTAssert(date.hasElapsed(seconds: 300, from: Date(fromString: "2016/03/22 09:40")!),
            "Date has elapsed.")
    }
}

// MARK: - String
extension DateTimeTests {
    
    func testStringToDate() {
        let date = Date(fromString: "1970/01/03 00:00")!
        let expected = Date(timeIntervalSince1970: TimeInterval(172800)
            - TimeInterval(TimeZone.current.secondsFromGMT())
            + TimeZone.current.daylightSavingTimeOffset())
        
        XCTAssertEqual(date, expected,
            "Date should be \(expected)")
    }
    
    func testDateToString() {
        let date = Date(fromString: "1970/01/03 20:43")!
        let expected = date.string(format: "MMM d, h:mm a")
        
        XCTAssertEqual("Jan 3, 8:43 PM", expected,
            "Date string should be \(expected)")
    }
}

// MARK: - Increments
extension DateTimeTests {
    
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
            calendar.startOfDay(for: tomorrow),
            "Incremented date by today should be \(tomorrow)")
    }
    
    func testIncrementZeroDay() {
        let fromDate = Date(fromString: "2015/10/26 18:31")!
        let incrementedDate = fromDate.increment(days: 0)
        
        XCTAssertEqual(incrementedDate, fromDate,
            "Incremented date by zero should be \(fromDate)")
    }
    
    func testIncrementOneDay() {
        let fromDate = Date(fromString: "2050/02/15 05:06")!
        let incrementedDate = fromDate.increment(days: 1)
        let expectedDate = Date(fromString: "2050/02/16 05:06")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by one should be \(String(describing: expectedDate))")
    }
    
    func testIncrementTwoDay() {
        let fromDate = Date(fromString: "1990/01/31 22:12")!
        let incrementedDate = fromDate.increment(days: 2)
        let expectedDate = Date(fromString: "1990/02/02 22:12")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by two should be \(String(describing: expectedDate))")
    }
    
    func testIncrementLeapYearDay() {
        let fromDate = Date(fromString: "2016/02/20 13:12")!
        let incrementedDate = fromDate.increment(days: 10)
        let expectedDate = Date(fromString: "2016/03/01 13:12")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by two should be \(String(describing: expectedDate))")
    }
    
    func testIncrementDayIfPast() {
        let fromDate = Date(fromString: "1999/01/15 10:15")!
        let incrementedDate = fromDate.incrementDayIfPast()
        let expectedDate = Date(fromString: "1999/01/16 10:15")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date if past should be \(String(describing: expectedDate))")
    }
    
    func testIncrementDayIfPastForFuture() {
        let fromDate = Date(fromString: "2050/01/15 10:15")!
        let incrementedDate = fromDate.incrementDayIfPast()
        let expectedDate = Date(fromString: "2050/01/15 10:15")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date if past should be \(String(describing: expectedDate))")
    }
    
    func testIncrementMinute() {
        let fromDate = Date(fromString: "2015/09/18 18:31")!
        let incrementedDate = fromDate.increment(minutes: 1)
        let expectedDate = Date(fromString: "2015/09/18 18:32")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by minute should be \(String(describing: expectedDate))")
    }
    
    func testIncrementNintyFiveMinutes() {
        let fromDate = Date(fromString: "2015/12/14 07:04")!
        let incrementedDate = fromDate.increment(minutes: 95)
        let expectedDate = Date(fromString: "2015/12/14 08:39")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by 95 minutes should be \(String(describing: expectedDate))")
    }
    
    func testIncrementDayByMinutes() {
        let fromDate = Date(fromString: "2015/04/02 13:15")!
        let incrementedDate = fromDate.increment(minutes: 1445)
        let expectedDate = Date(fromString: "2015/04/03 13:20")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by day's worth of minutes should be \(String(describing: expectedDate))")
    }
}

extension DateTimeTests {
    
    func testHijriDate() {
        let gregorianDate = Date(fromString: "2015/09/23 12:30")!
        let hijriDate = gregorianDate.hijriString()
        let expectedDate = "Dhuʻl-Hijjah 9, 1436 AH"
        
        XCTAssertEqual("\(hijriDate)", expectedDate,
            "Incremented date by minute should be \(expectedDate)")
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
