//
//  BackgroundTask.swift
//  https://gist.github.com/phatmann/e96958529cc86ff584a9
//  ZamzamKit
//
//  Created by Basem Emara on 3/15/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import UIKit

/// Encapsulate iOS background tasks
public class BackgroundTask {
    private let application: UIApplication
    fileprivate var identifier: UIBackgroundTaskIdentifier = .invalid
    
    private init(application: UIApplication) {
        self.application = application
    }
    
    /// Execute a process with an indefinite background task. The handler must call `end()` when it is done.
    ///
    /// This method lets your app continue to run for a period of time after it transitions to the background.
    /// You should call this method at times where leaving a task unfinished might be detrimental to your app’s user experience.
    ///
    ///     BackgroundTask.run(for: application) { task in
    ///         // Perform finite-length task...
    ///         task.end() // Always end task when finished
    ///     }
    ///
    /// - Parameters:
    ///   - application: The application instance.
    ///   - handler: The long-running background task to execute.
    public static func run(for application: UIApplication, handler: (BackgroundTask) -> Void) {
        // https://gist.github.com/phatmann/e96958529cc86ff584a9
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
