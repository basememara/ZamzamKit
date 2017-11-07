//
//  UNNotificationTriggerDateType.swift
//  ZamzamKit
//
//  Created by Basem Emara on 6/4/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UserNotifications

public protocol UNNotificationTriggerDateType {
    func nextTriggerDate() -> Date?
}

extension UNCalendarNotificationTrigger: UNNotificationTriggerDateType {}
extension UNTimeIntervalNotificationTrigger: UNNotificationTriggerDateType {}
