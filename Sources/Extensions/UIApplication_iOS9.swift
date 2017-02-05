//
//  UIApplication_iOS9.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/27/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

@available(iOS, deprecated: 9.3)
public extension UIApplication {
    
    func registerUserNotificationSettings(
        _ actions: [UIMutableUserNotificationAction]? = nil,
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        type: UIUserNotificationType = [ .alert, .badge, .sound ]) {
            let notificationSettings: UIUserNotificationSettings
            var mainCategory: UIMutableUserNotificationCategory? = nil
            
            // Setup actions if applicable
            if let a = actions, !a.isEmpty {
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
            if let id = identifier, removeDuplicates {
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
        self.scheduledLocalNotifications?.forEach {
            // Find matching to delete
            guard let id = $0.userInfo?[ZamzamConstants.Notification.IDENTIFIER_KEY] as? String, id == identifier else { return }
            self.cancelLocalNotification($0)
        }
    }
    
    func hasLocalNotification(_ identifier: String) -> Bool {
        return self.scheduledLocalNotifications?.contains {
            ($0.userInfo?[ZamzamConstants.Notification.IDENTIFIER_KEY] as? String) == identifier
        } == true
    }
    
    func getLocalNotifications(_ identifier: String) -> [UILocalNotification] {
        return self.scheduledLocalNotifications?.filter {
            guard let id = $0.userInfo?[ZamzamConstants.Notification.IDENTIFIER_KEY] as? String, id == identifier else { return false }
            return true
        } ?? []
    }
    
    public func clearNotificationTray() {
        // No native API so work around
        self.applicationIconBadgeNumber = 1
        self.applicationIconBadgeNumber = 0
    }
    
}
