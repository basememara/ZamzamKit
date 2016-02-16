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

class DateTimeHelperTests: XCTestCase {
    
    var dateTimeHelper: DateTimeHelper!
    var formatter: NSDateFormatter!
    
    override func setUp() {
        super.setUp()
        
        dateTimeHelper = DateTimeHelper()
        
        formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
    }
    
    func testGetCurrentTimeInDecimal() {
        let fromDate = formatter.dateFromString("2012/10/23 18:15")!
        let time = dateTimeHelper.getCurrentTimeInDecimal(fromDate)
        let expectedTime = 18.25
        
        XCTAssertEqual(time, expectedTime,
            "Day of week should be \(expectedTime)")
    }
    
    func testIncrementToday() {
        let incrementedDate = dateTimeHelper.incrementDay()
        let tomorrow = NSDate.tomorrow()
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        XCTAssertEqual(
            calendar.startOfDayForDate(incrementedDate),
            calendar.startOfDayForDate(tomorrow),
            "Incremented date by today should be \(tomorrow)")
    }
    
    func testIncrementZeroDay() {
        let fromDate = formatter.dateFromString("2015/10/26 18:31")!
        let incrementedDate = dateTimeHelper.incrementDay(fromDate, numberOfDays: 0)
        
        XCTAssertEqual(incrementedDate, fromDate,
            "Incremented date by zero should be \(fromDate)")
    }
    
    func testIncrementOneDay() {
        let fromDate = formatter.dateFromString("2050/02/15 05:06")!
        let incrementedDate = dateTimeHelper.incrementDay(fromDate, numberOfDays: 1)
        let expectedDate = formatter.dateFromString("2050/02/16 05:06")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by one should be \(expectedDate)")
    }
    
    func testIncrementTwoDay() {
        let fromDate = formatter.dateFromString("1990/01/31 22:12")!
        let incrementedDate = dateTimeHelper.incrementDay(fromDate, numberOfDays: 2)
        let expectedDate = formatter.dateFromString("1990/02/02 22:12")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by two should be \(expectedDate)")
    }
    
    func testIncrementLeapYearDay() {
        let fromDate = formatter.dateFromString("2016/02/20 13:12")!
        let incrementedDate = dateTimeHelper.incrementDay(fromDate, numberOfDays: 10)
        let expectedDate = formatter.dateFromString("2016/03/01 13:12")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by two should be \(expectedDate)")
    }
    
    func testIncrementDayIfPast() {
        let fromDate = formatter.dateFromString("1999/01/15 10:15")!
        let incrementedDate = dateTimeHelper.incrementDayIfPast(fromDate)
        let expectedDate = formatter.dateFromString("1999/01/16 10:15")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date if past should be \(expectedDate)")
    }
    
    func testIncrementDayIfPastForFuture() {
        let fromDate = formatter.dateFromString("2050/01/15 10:15")!
        let incrementedDate = dateTimeHelper.incrementDayIfPast(fromDate)
        let expectedDate = formatter.dateFromString("2050/01/15 10:15")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date if past should be \(expectedDate)")
    }
    
    func testIncrementMinute() {
        let fromDate = formatter.dateFromString("2015/09/18 18:31")!
        let incrementedDate = dateTimeHelper.incrementMinutes(fromDate)
        let expectedDate = formatter.dateFromString("2015/09/18 18:32")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by minute should be \(expectedDate)")
    }
    
    func testIncrementNintyFiveMinutes() {
        let fromDate = formatter.dateFromString("2015/12/14 07:04")!
        let incrementedDate = dateTimeHelper.incrementMinutes(fromDate, numberOfMinutes: 95)
        let expectedDate = formatter.dateFromString("2015/12/14 08:39")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by 95 minutes should be \(expectedDate)")
    }
    
    func testIncrementDayByMinutes() {
        let fromDate = formatter.dateFromString("2015/04/02 13:15")!
        let incrementedDate = dateTimeHelper.incrementMinutes(fromDate, numberOfMinutes: 1445)
        let expectedDate = formatter.dateFromString("2015/04/03 13:20")
        
        XCTAssertEqual(incrementedDate, expectedDate,
            "Incremented date by day's worth of minutes should be \(expectedDate)")
    }
    
    func testGetHijriDate() {
        let gregorianDate = formatter.dateFromString("2015/09/23 12:30")!
        let hijriDate = dateTimeHelper.getHijriDate(gregorianDate)
        let expectedDate = "Dhuʻl-Hijjah 9, 1436 AH"
        
        XCTAssertEqual("\(hijriDate)", expectedDate,
            "Incremented date by minute should be \(expectedDate)")
    }
    
}
