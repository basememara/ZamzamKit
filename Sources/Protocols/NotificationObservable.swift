//
//  NotificationObservable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/5/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

public protocol NotificationObservable: class { }

public extension NotificationObservable {
    
    /// Adds an entry to the receiver’s dispatch table with an observer, a notification selector and optional criteria: notification name and sender.
    ///
    /// - Parameters:
    ///   - name: The name of the notification for which to register the observer; that is, only notifications with this name are delivered to the observer.
    ///   - selector: Selector that specifies the message the receiver sends observer to notify it of the notification posting.
    ///   - object: The object whose notifications the observer wants to receive; that is, only notifications sent by this sender are delivered to the observer.
    func addObserver(for name: NSNotification.Name, selector: Selector, object: Any? = nil) {
        NotificationCenter.default.addObserver(self,
            selector: selector,
            name: name,
            object: object
        )
    }
}
