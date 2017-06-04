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


@available(iOSApplicationExtension 10.0, *)
@available(tvOS 10.0, *)
@available(watchOS 3.0, *)
extension UNCalendarNotificationTrigger: UNNotificationTriggerDateType {}

@available(iOSApplicationExtension 10.0, *)
@available(tvOS 10.0, *)
@available(watchOS 3.0, *)
extension UNTimeIntervalNotificationTrigger: UNNotificationTriggerDateType {}
