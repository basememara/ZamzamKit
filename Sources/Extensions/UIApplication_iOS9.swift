//
//  UIApplication_iOS9.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/27/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

@available(iOS 9.3, *)
public extension UIApplication {
    
    func registerUserNotificationSettings(
        _ actions: [UIMutableUserNotificationAction]? = nil,
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        type: UIUserNotificationType = [ .alert, .badge, .sound ]) {
            let notificationSettings: UIUserNotificationSettings
            var mainCategory: UIMutableUserNotificationCategory? = nil
            
            // Setup actions if applicable
            if let a = actions, a.count > 0 {
                // Notification category
                mainCategory = UIMutableUserNotificationCategory()
                mainCategory!.identifier = category
                mainCategory!.setActions(a, for: .default)
                mainCategory!.setActions(a, for: .minimal) // TODO: add first 2
            }
            
            // Configure notifications
            notificationSettings = UIUserNotificationSettings(
                types: type,
                categories: mainCategory != nil
                    ? [mainCategory!]
                    : nil)
            
            // Register notifications
            self.registerUserNotificationSettings(notificationSettings)
    }
    
    func scheduleLocalNotification(
        _ date: Date,
        body: String,
        title: String? = nil,
        identifier: String? = nil,
        userInfo: [String: Any]? = nil,
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        badge: Int = 0,
        sound: String? = UILocalNotificationDefaultSoundName,
        occurrence: NSCalendar.Unit? = nil,
        incrementDayIfPast: Bool = false,
        removeDuplicates: Bool = false) {
            // De-dup previous notifications if applicable
            if let id = identifier , removeDuplicates {
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
    
    func removeLocalNotification(_ identifier: String) {
        guard let notifications = self.scheduledLocalNotifications
            , notifications.count > 0 else {
                return
        }
        
        for item in notifications {
            // Find matching to delete
            if let id = item.userInfo?[ZamzamConstants.Notification.IDENTIFIER_KEY] as? String
                , id == identifier {
                    // Cancel notification
                    self.cancelLocalNotification(item)
            }
        }
    }
    
    func hasLocalNotification(_ identifier: String) -> Bool {
        guard let notifications = self.scheduledLocalNotifications
            , notifications.count > 0 else {
                return false
        }
        
        for item in notifications {
            // Find matching to delete
            if let id = item.userInfo?[ZamzamConstants.Notification.IDENTIFIER_KEY] as? String
                , id == identifier {
                    return true
            }
        }
        
        return false
    }
    
    func getLocalNotifications(_ identifier: String) -> [UILocalNotification] {
        var matchedNotifications: [UILocalNotification] = []
        
        guard let notifications = self.scheduledLocalNotifications
            , notifications.count > 0 else {
                return matchedNotifications
        }
        
        for item in notifications {
            // Find matching to delete
            if let id = item.userInfo?[ZamzamConstants.Notification.IDENTIFIER_KEY] as? String
                , id == identifier {
                    matchedNotifications.append(item)
            }
        }
        
        return matchedNotifications
    }
    
    public func clearNotificationTray() {
        // No native API so work around
        self.applicationIconBadgeNumber = 1
        self.applicationIconBadgeNumber = 0
    }
    
}
