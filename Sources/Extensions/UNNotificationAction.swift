//
//  UNNotificationAction.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/31/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UserNotifications

@available(iOS 10, watchOS 3, tvOS 10, *)
public extension UNNotificationAction {

    convenience init(identifier: String, title: String) {
        self.init(identifier: identifier, title: title, options: [.foreground])
    }
}
