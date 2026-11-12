//
//  NotificationCenter.swift
//  ZamzamCore
//
//  Created by Basem Emara on 5/5/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation

public extension NotificationCenter {
    /// Posts a notification with the given name and user info, and no sender.
    func post(name: NSNotification.Name, userInfo: [AnyHashable: Any]? = nil) {
        post(name: name, object: nil, userInfo: userInfo)
    }
}
