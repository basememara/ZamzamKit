//
//  LogManager.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2026-10-12.
//  Copyright © 2026 Zamzam Inc. All rights reserved.
//

import SwiftUI
import ZamzamCore

public extension LogManager {
    /// Records the scene phase on every future log entry, so it can be read outside the main thread.
    func set(context newPhase: ScenePhase) {
        set(newPhase.rawString, forKey: "app_state")
    }
}

private extension ScenePhase {
    var rawString: String {
        switch self {
        case .active:
            "active"
        case .background:
            "background"
        case .inactive:
            "inactive"
        @unknown default:
            "unknown"
        }
    }
}
