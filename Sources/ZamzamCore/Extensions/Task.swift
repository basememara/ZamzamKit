//
//  Task.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2022-01-18.
//  Copyright © 2022 Zamzam Inc. All rights reserved.
//

import Foundation.NSDate

public extension Task where Success == Never, Failure == Never {
    /// Suspends the current task for at least the given time interval in seconds.
    ///
    /// If the task is canceled before the time ends, this function throws `CancellationError`. This function doesn't block the underlying thread.
    static func sleep(seconds duration: TimeInterval) async throws {
        guard duration > 0 else { return }
        try await sleep(nanoseconds: UInt64(duration * TimeInterval(NSEC_PER_SEC)))
    }
}
