//
//  NotificationTriggerTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2026-10-12.
//  Copyright © 2026 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import UserNotifications
import ZamzamCore
@testable import ZamzamNotification

struct NotificationTriggerTests {
    private let newYork = Calendar(identifier: .gregorian, timeZone: TimeZone(identifier: "America/New_York") ?? .gmt)
    private let utc = Calendar(identifier: .gregorian, timeZone: .gmt)
}

extension NotificationTriggerTests {
    @Test
    func aOneTimeTriggerFiresAtItsInstantInTheRepeatedHour() throws {
        // 01:26 EST on November 7, 2032, the second time New York's clocks read 01:26 that night
        let date = try #require(utc.date(from: DateComponents(year: 2032, month: 11, day: 7, hour: 6, minute: 26)))
        #expect(newYork.component(.hour, from: date) == 1)
        #expect(newYork.component(.hour, from: date - 3600) == 1)

        let trigger = UNCalendarNotificationTrigger(date: date)

        #expect(trigger.nextTriggerDate() == date)
    }

    @Test
    func aRepeatingTriggerKeepsTheWallClockOfItsCalendar() {
        let trigger = UNCalendarNotificationTrigger(date: Date(timeIntervalSince1970: 0), repeats: .day, calendar: newYork)

        #expect(trigger.dateComponents.timeZone == newYork.timeZone)
        #expect(trigger.dateComponents.hour == 19)
        #expect(trigger.repeats)
    }
}

extension NotificationTriggerTests {
    @Test
    func aRepeatingIntervalUnderAMinuteThrows() throws {
        #expect(throws: ZamzamError.self) {
            try UNUserNotificationCenter.trigger(after: 30, repeats: true)
        }

        #expect(try UNUserNotificationCenter.trigger(after: 60, repeats: true)?.repeats == true)
        #expect(try UNUserNotificationCenter.trigger(after: 30, repeats: false)?.timeInterval == 30)
        #expect(try UNUserNotificationCenter.trigger(after: 0, repeats: true) == nil)
    }
}
