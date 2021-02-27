//
//  NotificationCenter.swift
//  ZamzamCore
//
//  Created by Basem Emara on 5/5/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation

public extension NotificationCenter {
    /// Creates a notification with a given name, sender, and information and posts it to the receiver.
    ///
    /// - Parameters:
    ///   - name: The name of the notification.
    ///   - userInfo: Information about the the notification. May be nil.
    func post(name: NSNotification.Name, userInfo: [AnyHashable: Any]? = nil) {
        post(name: name, object: nil, userInfo: userInfo)
    }

    /// Adds an entry to the receiver’s dispatch table with an observer, a notification selector and optional criteria: notification name and sender.
    ///
    /// - Parameters:
    ///   - observer: Object registering as an observer.
    ///   - selector: Selector that specifies the message the receiver sends observer to notify it of the notification posting.
    ///   - name: The name of the notification for which to register the observer; that is, only notifications with this name are delivered to the observer.
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name) {
        addObserver(observer, selector: aSelector, name: aName, object: nil)
    }

    /// Removes matching entries from the notification center's dispatch table.
    ///
    /// - Parameters:
    ///   - observer: Object registering as an observer.
    ///   - name: The name of the notification for which to register the observer; that is, only notifications with this name are delivered to the observer.
    func removeObserver(_ observer: Any, name aName: NSNotification.Name) {
        removeObserver(observer, name: aName, object: nil)
    }
}
