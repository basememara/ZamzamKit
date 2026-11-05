//
//  TimelineScheduleTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2026-11-05.
//  Copyright © 2026 Zamzam Inc. All rights reserved.
//

import Foundation
import SwiftUI
import Testing
import ZamzamUI

struct TimelineScheduleTests {
    @Test func openEndedKeepsADateAfterItsLast() throws {
        let start = Date(timeIntervalSince1970: 1_800_000_000)
        let dates = [start, start + 60, start + 120]

        let entries = ExplicitTimelineSchedule<[Date]>.openEnded(dates).entries(from: start, mode: .normal)

        #expect(Array(entries.prefix(dates.count)) == dates)
        let last = try #require(entries.last)
        #expect(last > start + 120)
    }
}
