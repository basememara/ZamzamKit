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

        let trigger = UNCalendarNotificationTrigger(date: date, repeats: .once, calendar: newYork)

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
