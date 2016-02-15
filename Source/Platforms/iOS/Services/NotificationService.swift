//
//  NotificationService.swift
//  Pods
//
//  Created by Basem Emara on 1/20/16.
//
//

import Foundation
import ZamzamKit

public extension NotificationService {
    
    public func register(application: UIApplication,
        actions: [UIMutableUserNotificationAction]? = nil,
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        type: UIUserNotificationType = [.Alert, .Badge, .Sound]) {
            let notificationSettings: UIUserNotificationSettings
            var mainCategory: UIMutableUserNotificationCategory? = nil
            
            // Setup actions if applicable
            if let a = actions where a.count > 0 {
                // Notification category
                mainCategory = UIMutableUserNotificationCategory()
                mainCategory!.identifier = category
                mainCategory!.setActions(a, forContext: .Default)
                mainCategory!.setActions(Array(a.prefix(2)), forContext: .Minimal)
            }
            
            // Configure notifications
            notificationSettings = UIUserNotificationSettings(
                forTypes: type,
                categories: mainCategory != nil
                    ? NSSet(objects: mainCategory!) as? Set<UIUserNotificationCategory>
                    : nil)
            
            // Register notifications
            application.registerUserNotificationSettings(notificationSettings)
    }
    
    /*public func register(application: UIApplication,
        categoryActions: [String: [UIMutableUserNotificationAction]],
        type: UIUserNotificationType = [.Alert, .Badge, .Sound]) {
            let notificationSettings: UIUserNotificationSettings
            
            for category in categoryActions {
                for action in category.1 {
                    
                }
            }
            
            // Setup actions if applicable
            if let a = actions where a.count > 0 {
                // Notification category
                mainCategory = UIMutableUserNotificationCategory()
                mainCategory!.identifier = category
                mainCategory!.setActions(a, forContext: .Default)
                mainCategory!.setActions(Array(a.prefix(2)), forContext: .Minimal)
            }
            
            // Configure notifications
            notificationSettings = UIUserNotificationSettings(
                forTypes: type,
                categories: mainCategory != nil
                    ? NSSet(objects: mainCategory!) as? Set<UIUserNotificationCategory>
                    : nil)
            
            // Register notifications
            application.registerUserNotificationSettings(notificationSettings)
    }*/
    
    public func create(date: NSDate,
        body: String,
        title: String? = nil,
        identifier: String? = nil,
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        badge: Int = 0,
        sound: String? = UILocalNotificationDefaultSoundName,
        `repeat`: NSCalendarUnit? = nil,
        incrementDayIfPast: Bool = true) -> UILocalNotification {
            // Initialize and configure notification
            let notification = UILocalNotification()
            notification.category = category
            notification.alertBody = body
            notification.fireDate = incrementDayIfPast
                ? dateTimeHelper.incrementDayIfPast(date) : date
            
            if let t = title where t != "" {
                notification.alertTitle = t
            }
            
            if let s = sound where s != "" {
                notification.soundName = s
            }
            
            if let r = `repeat` {
                notification.repeatInterval = r
            }
            
            // Provide unique identifier for later use
            if let id = identifier where id != "" {
                notification.userInfo = [ZamzamConstants.Notification.IDENTIFIER_KEY: id]
            }
            
            if badge > 0 {
                notification.applicationIconBadgeNumber = badge
            }
            
            return notification
    }
    
    public func schedule(application: UIApplication, date: NSDate, body: String,
        title: String? = nil,
        identifier: String? = nil,
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        badge: Int = 0,
        sound: String? = UILocalNotificationDefaultSoundName,
        `repeat`: NSCalendarUnit? = nil,
        incrementDayIfPast: Bool = true,
        removeDuplicates: Bool = false) {
            // De-dup previous notifications if applicable
            if let id = identifier where removeDuplicates {
                remove(application, id)
            }
            
            let notification = create(date,
                body: body,
                title: title,
                identifier: identifier,
                category: category,
                badge: badge,
                sound: sound,
                `repeat`: `repeat`,
                incrementDayIfPast: incrementDayIfPast)
            
            application.scheduleLocalNotification(notification)
    }
    
    public func remove(application: UIApplication, _ identifier: String) {
        guard let notifications = application.scheduledLocalNotifications
            where notifications.count > 0 else {
            return
        }
        
        for item in notifications {
            // Find matching to delete
            if let userInfo = item.userInfo as? [String: String]
                where userInfo[ZamzamConstants.Notification.IDENTIFIER_KEY] == identifier {
                    // Cancel notification
                    application.cancelLocalNotification(item)
            }
        }
    }
    
    public func exists(application: UIApplication, _ identifier: String) -> Bool {
        guard let notifications = application.scheduledLocalNotifications
            where notifications.count > 0 else {
                return false
        }
        
        for item in notifications {
            // Find matching to delete
            if let userInfo = item.userInfo as? [String: String]
                where userInfo[ZamzamConstants.Notification.IDENTIFIER_KEY] == identifier {
                    return true
            }
        }
        
        return false
    }
    
    public func getByIdentifier(application: UIApplication, _ identifier: String) -> [UILocalNotification] {
        var matchedNotifications: [UILocalNotification] = []
        
        guard let notifications = application.scheduledLocalNotifications
            where notifications.count > 0 else {
                return matchedNotifications
        }
        
        for item in notifications {
            // Find matching to delete
            if let userInfo = item.userInfo as? [String: String]
                where userInfo[ZamzamConstants.Notification.IDENTIFIER_KEY] == identifier {
                    matchedNotifications.append(item)
            }
        }
        
        return matchedNotifications
    }
    
}