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

public extension NotificationCenter {
    
    /// Wraps the observer token received from `addObserver` and automatically unregisters from the notification center on deinit.
    ///
    /// To cancel the subscription, assign `nil` to this object any time to release.
    final class Cancellable: NSObject {
        // https://oleb.net/blog/2018/01/notificationcenter-removeobserver/
        private let notificationCenter: NotificationCenter
        private let token: Any
        
        public init(notificationCenter: NotificationCenter = .default, token: Any) {
            self.notificationCenter = notificationCenter
            self.token = token
        }
        
        deinit {
            notificationCenter.removeObserver(token)
        }
    }
    
    /// Adds an entry to the notification center's dispatch table that includes a notification queue and a block to add to the queue, and an optional notification name and sender.
    ///
    ///     class MyObserver: NSObject {
    ///         var cancellable: NotificationCenter.Cancellable? // Auto-released in deinit
    ///
    ///         func setup() {
    ///             NotificationCenter.default.addObserver(forName: .SomeName, in: &token) {
    ///                 print("test")
    ///             }
    ///         }
    ///     }
    ///
    /// The observation is automatically released on deinit within the token wrapper; there is no need to manually unregister.
    ///
    /// - Parameters:
    ///   - name: The name of the notification for which to register the observer; that is, only notifications with this name are delivered to the observer.
    ///   - object: The object whose notifications the observer wants to receive; that is, only notifications sent by this sender are delivered to the observer.
    ///   - queue: The operation queue to which block should be added. If you pass nil, the block is run synchronously on the posting thread.
    ///   - cancellable: An opaque object to act as the observer and will manage its auto release.
    ///   - block: The block to be executed when the notification is received.
    func addObserver(
        forName name: NSNotification.Name,
        object: Any? = nil,
        queue: OperationQueue? = nil,
        in cancellable: inout Cancellable?,
        using block: @escaping (Notification) -> Void
    ) {
        cancellable = Cancellable(
            notificationCenter: self,
            token: addObserver(forName: name, object: object, queue: queue, using: block)
        )
    }
}
