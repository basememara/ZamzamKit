//
//  DateTimeHelperTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import XCTest
import Timepiece
@testable import ZamzamKit

class DateTimeTests: XCTestCase {
    
    func testStringToDate() {
        let date = NSDate(fromString: "1970/01/03 00:00")!
        let expected = NSDate(timeIntervalSince1970:
            NSTimeInterval(172800 - Int(NSTimeZone.localTimeZone().secondsFromGMT)))
        
        XCTAssertEqual(date, expected,
            "Day of week should be \(expected)")
    }
    
    func testGetCurrentTimeInDecimal() {
        let time = NSDate(fromString: "2012/10/23 18:15")!.timeToDecimal()
        let expectedTime = 18.25
        
        XCTAssertEqual(time, expectedTime,
            "Day of week should be \(expectedTime)")
    }
    
    func testIncrementToday() {
        let incrementedDate = NSDate().incrementDay()
        let tomorrow = NSDate.tomorrow()
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        XCTAssertEqual(
            calendar.startOfDayForDate(incrementedDate),
            calendar.startOfDayForDate(tomorrow),
            "Incremented date by today should be \(tomorrow)")
    }
    
    func testIncrementZeroDay() {
        let fromDate = NSDate(fromString: "2015/10/26 18:31")!
        let incrementedDate = fromDate.incrementDay(0)
        
        XCTAssertEqual(incrementedDate, fromDate,
            "Incremented date by zero should be \(fromDate)")
    }
    
    func testIncrementOneDay() {
        let fromDate = NSDate(fromString: "2050/02/15 05:06")!
        let incrementedDate = fromDate.incrementDay(1)
        let expectedDate = NSDate(fromString: "2050/02/16 05:06")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by one should be \(expectedDate)")
    }
    
    func testIncrementTwoDay() {
        let fromDate = NSDate(fromString: "1990/01/31 22:12")!
        let incrementedDate = fromDate.incrementDay(2)
        let expectedDate = NSDate(fromString: "1990/02/02 22:12")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by two should be \(expectedDate)")
    }
    
    func testIncrementLeapYearDay() {
        let fromDate = NSDate(fromString: "2016/02/20 13:12")!
        let incrementedDate = fromDate.incrementDay(10)
        let expectedDate = NSDate(fromString: "2016/03/01 13:12")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by two should be \(expectedDate)")
    }
    
    func testIncrementDayIfPast() {
        let fromDate = NSDate(fromString: "1999/01/15 10:15")!
        let incrementedDate = fromDate.incrementDayIfPast()
        let expectedDate = NSDate(fromString: "1999/01/16 10:15")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date if past should be \(expectedDate)")
    }
    
    func testIncrementDayIfPastForFuture() {
        let fromDate = NSDate(fromString: "2050/01/15 10:15")!
        let incrementedDate = fromDate.incrementDayIfPast()
        let expectedDate = NSDate(fromString: "2050/01/15 10:15")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date if past should be \(expectedDate)")
    }
    
    func testIncrementMinute() {
        let fromDate = NSDate(fromString: "2015/09/18 18:31")!
        let incrementedDate = fromDate.incrementMinutes()
        let expectedDate = NSDate(fromString: "2015/09/18 18:32")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by minute should be \(expectedDate)")
    }
    
    func testIncrementNintyFiveMinutes() {
        let fromDate = NSDate(fromString: "2015/12/14 07:04")!
        let incrementedDate = fromDate.incrementMinutes(95)
        let expectedDate = NSDate(fromString: "2015/12/14 08:39")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by 95 minutes should be \(expectedDate)")
    }
    
    func testIncrementDayByMinutes() {
        let fromDate = NSDate(fromString: "2015/04/02 13:15")!
        let incrementedDate = fromDate.incrementMinutes(1445)
        let expectedDate = NSDate(fromString: "2015/04/03 13:20")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by day's worth of minutes should be \(expectedDate)")
    }
    
    func testGetHijriDate() {
        let gregorianDate = NSDate(fromString: "2015/09/23 12:30")!
        let hijriDate = gregorianDate.toHijriString()
        let expectedDate = "Dhuʻl-Hijjah 9, 1436 AH"
        
        XCTAssertEqual("\(hijriDate)", expectedDate,
            "Incremented date by minute should be \(expectedDate)")
    }
    
    func testHasElapsed() {
        let date = NSDate(fromString: "2016/03/22 09:30")!
        
        XCTAssert(date.hasElapsed(300, fromDate: NSDate(fromString: "2016/03/22 09:40")!),
            "Date has elapsed.")
    }
    
}
