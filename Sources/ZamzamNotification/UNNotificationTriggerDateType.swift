//
//  UNNotificationTriggerDateType.swift
//  ZamzamKit
//
//  Created by Basem Emara on 6/4/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import UserNotifications

public protocol UNNotificationTriggerDateType {
    func nextTriggerDate() -> Date?
}

// TODO: Next trigger date broken on Apple's side
// Either remove or abstract bug away
// https://openradar.appspot.com/32865247
// https://stackoverflow.com/q/40411812

extension UNCalendarNotificationTrigger: UNNotificationTriggerDateType {}
extension UNTimeIntervalNotificationTrigger: UNNotificationTriggerDateType {}
