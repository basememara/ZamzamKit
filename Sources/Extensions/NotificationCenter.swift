//
//  NotificationCenter.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/23/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

public extension NotificationCenter {
    
    /// Adds an entry to the receiver’s dispatch table with a notification queue and a block to add to the queue.
    ///
    /// - Parameters:
    ///   - name: The name of the notification for which to register the observer.
    ///   - block: he block to be executed when the notification is received.
    func addObserver(for name: NSNotification.Name, using block: @escaping () -> Void) {
        NotificationCenter.default.addObserver(
            forName: name,
            object: nil,
            queue: nil,
            using: { _ in block() }
        )
    }
}
