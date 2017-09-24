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
