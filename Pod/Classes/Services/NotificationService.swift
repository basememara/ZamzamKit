//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public class NotificationService: NSObject {
    
    let dateTimeHelper: DateTimeHelper!
    
    override init() {
        // Inject service dependencies
        dateTimeHelper = DateTimeHelper()
    }
    
}

public extension NotificationService {
    
    public func register(application: UIApplication,
        _ notifications: [UIMutableUserNotificationAction],
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        type: UIUserNotificationType = [.Alert, .Badge, .Sound]) {
            // Notification category
            let mainCategory = UIMutableUserNotificationCategory()
            mainCategory.identifier = category
            
            let defaultActions = notifications
            let minimalActions = notifications
            
            mainCategory.setActions(defaultActions, forContext: .Default)
            mainCategory.setActions(minimalActions, forContext: .Minimal)
            
            // Configure notifications
            let notificationSettings = UIUserNotificationSettings(
                forTypes: type,
                categories: NSSet(objects: mainCategory) as? Set<UIUserNotificationCategory>)
            
            // Register notifications
            application.registerUserNotificationSettings(notificationSettings)
    }
    
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
        if let notifications = application.scheduledLocalNotifications {
            for item in notifications {
                // Find matching to delete
                if let userInfo = item.userInfo as? [String: String]
                    where userInfo[ZamzamConstants.Notification.IDENTIFIER_KEY] == identifier {
                        // Cancel notification
                        application.cancelLocalNotification(item)
                }
            }
        }
    }
    
    public func exists(application: UIApplication, _ identifier: String) -> Bool {
        if let notifications = application.scheduledLocalNotifications {
            for item in notifications {
                // Find matching to delete
                if let userInfo = item.userInfo as? [String: String]
                    where userInfo[ZamzamConstants.Notification.IDENTIFIER_KEY] == identifier {
                        return true
                }
            }
        }
        
        return false
    }
    
    public func getByIdentifier(application: UIApplication, _ identifier: String) -> [UILocalNotification] {
        var matchedNotifications: [UILocalNotification] = []
        
        if let notifications = application.scheduledLocalNotifications {
            for item in notifications {
                // Find matching to delete
                if let userInfo = item.userInfo as? [String: String]
                    where userInfo[ZamzamConstants.Notification.IDENTIFIER_KEY] == identifier {
                        matchedNotifications.append(item)
                }
            }
        }
        
        return matchedNotifications
    }
    
}
