//
//  DateTimeHelperTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import XCTest
@testable import ZamzamKit

class DateTimeHelperTests: XCTestCase {
    
    var dateTimeHelper: DateTimeHelper!
    var tempDate: NSDate!
    
    override func setUp() {
        super.setUp()
        
        dateTimeHelper = DateTimeHelper()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        tempDate = formatter.dateFromString("2015/10/26 18:31")
    }
    
    func testIncrementDay() {
        let date1 = dateTimeHelper.incrementDay(tempDate, numberOfDays: 2)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date2 = formatter.dateFromString("2015/10/27 18:31")
        
        XCTAssertEqual(date1, date2, "Pass")
    }
    
}
