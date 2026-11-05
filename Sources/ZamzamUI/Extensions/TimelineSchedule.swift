//
//  TimelineSchedule.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2026-11-05.
//  Copyright © 2026 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension TimelineSchedule where Self == ExplicitTimelineSchedule<[Date]> {
    /// An explicit schedule that goes idle after its last date, where `.explicit(_:)` keeps updating its view.
    static func openEnded(_ dates: [Date]) -> Self {
        .explicit(dates + [.distantFuture])
    }
}
