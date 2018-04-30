//
//  NotificationCenter.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/5/17.
//  Copyright © 2017 Zamzam. All rights reserved.
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
}

public extension NotificationCenter {
    
    /// Adds an entry to the receiver’s dispatch table with an observer, a notification selector and optional criteria: notification name and sender.
    ///
    /// - Parameters:
    ///   - name: The name of the notification for which to register the observer; that is, only notifications with this name are delivered to the observer.
    ///   - selector: Selector that specifies the message the receiver sends observer to notify it of the notification posting.
    ///   - observer: Object registering as an observer.
    ///   - object: The object whose notifications the observer wants to receive; that is, only notifications sent by this sender are delivered to the observer.
    func addObserver(for name: NSNotification.Name, selector: Selector, from observer: Any, object: Any? = nil) {
        addObserver(observer, selector: selector, name: name, object: object)
    }
    
    /// Removes matching entries from the notification center's dispatch table.
    ///
    /// - Parameters:
    ///   - name: The name of the notification for which to register the observer; that is, only notifications with this name are delivered to the observer.
    ///   - observer: Object registering as an observer.
    ///   - object: The object whose notifications the observer wants to receive; that is, only notifications sent by this sender are delivered to the observer.
    func removeObserver(for name: NSNotification.Name, from observer: Any, object: Any? = nil) {
        removeObserver(observer, name: name, object: object)
    }
}
