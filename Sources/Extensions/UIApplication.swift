//
//  UIApplication.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import UIKit

public extension UIApplication {
    
    public func registerUserNotificationSettings(
        actions: [UIMutableUserNotificationAction]? = nil,
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        type: UIUserNotificationType = [ .Alert, .Badge, .Sound ]) {
            let notificationSettings: UIUserNotificationSettings
            var mainCategory: UIMutableUserNotificationCategory? = nil
            
            // Setup actions if applicable
            if let a = actions where a.count > 0 {
                // Notification category
                mainCategory = UIMutableUserNotificationCategory()
                mainCategory!.identifier = category
                mainCategory!.setActions(a, forContext: .Default)
                mainCategory!.setActions(a, forContext: .Minimal) // TODO: add first 2
            }
            
            // Configure notifications
            notificationSettings = UIUserNotificationSettings(
                forTypes: type,
                categories: mainCategory != nil
                    ? [mainCategory!]
                    : nil)
            
            // Register notifications
            self.registerUserNotificationSettings(notificationSettings)
    }
    
    public func scheduleLocalNotification(
        date: NSDate,
        body: String,
        title: String? = nil,
        identifier: String? = nil,
        userInfo: [String: AnyObject]? = nil,
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        badge: Int = 0,
        sound: String? = UILocalNotificationDefaultSoundName,
        occurrence: NSCalendarUnit? = nil,
        incrementDayIfPast: Bool = false,
        removeDuplicates: Bool = false) {
            // De-dup previous notifications if applicable
            if let id = identifier where removeDuplicates {
                self.removeLocalNotification(id)
            }
            
            let notification = UILocalNotification(
                date: date,
                body: body,
                title: title,
                identifier: identifier,
                userInfo: userInfo,
                category: category,
                badge: badge,
                sound: sound,
                occurrence: occurrence,
                incrementDayIfPast: incrementDayIfPast)
            
            self.scheduleLocalNotification(notification)
    }
    
    public func removeLocalNotification(identifier: String) {
        guard let notifications = self.scheduledLocalNotifications
            where notifications.count > 0 else {
                return
        }
        
        for item in notifications {
            // Find matching to delete
            if let identifier = item.userInfo?[ZamzamConstants.Notification.IDENTIFIER_KEY] as? String
                where identifier == identifier {
                    // Cancel notification
                    self.cancelLocalNotification(item)
            }
        }
    }
    
    public func hasLocalNotification(identifier: String) -> Bool {
        guard let notifications = self.scheduledLocalNotifications
            where notifications.count > 0 else {
                return false
        }
        
        for item in notifications {
            // Find matching to delete
            if let identifier = item.userInfo?[ZamzamConstants.Notification.IDENTIFIER_KEY] as? String
                where identifier == identifier {
                    return true
            }
        }
        
        return false
    }
    
    public func getLocalNotifications(identifier: String) -> [UILocalNotification] {
        var matchedNotifications: [UILocalNotification] = []
        
        guard let notifications = self.scheduledLocalNotifications
            where notifications.count > 0 else {
                return matchedNotifications
        }
        
        for item in notifications {
            // Find matching to delete
            if let identifier = item.userInfo?[ZamzamConstants.Notification.IDENTIFIER_KEY] as? String
                where identifier == identifier {
                    matchedNotifications.append(item)
            }
        }
        
        return matchedNotifications
    }
    
}