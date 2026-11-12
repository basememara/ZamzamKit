//
//  BackgroundTask.swift
//  ZamzamCore
//
//  Created by Basem Emara on 3/15/17.
//  https://gist.github.com/phatmann/e96958529cc86ff584a9
//
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit.UIApplication

/// Encapsulate iOS background tasks
public class BackgroundTask {
    private let application: UIApplication
    private var identifier: UIBackgroundTaskIdentifier = .invalid

    private init(application: UIApplication) {
        self.application = application
    }

    /// Starts a background task and passes it to `handler`, which must call `end()` when its work is done.
    ///
    ///     BackgroundTask.run(for: application) { task in
    ///         // Finish the work, then:
    ///         task.end()
    ///     }
    ///
    /// The task also ends when the app's background time runs out.
    @MainActor
    public static func run(for application: UIApplication, handler: (BackgroundTask) -> Void) {
        let backgroundTask = BackgroundTask(application: application)

        // Mark the beginning of a new long-running background task
        backgroundTask.identifier = application.beginBackgroundTask {
            backgroundTask.end()
        }

        handler(backgroundTask)
    }

    /// Marks the end of a specific long-running background task.
    public func end() {
        if identifier != .invalid {
            application.endBackgroundTask(identifier)
        }

        identifier = .invalid
    }
}
#endif
