//
//  UILocalNotification.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import UIKit

@available(iOS, deprecated: 9.3)
public extension UILocalNotification {
    
    convenience init(
        date: Date,
        body: String,
        title: String? = nil,
        identifier: String? = nil,
        userInfo: [String: Any]? = nil,
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        badge: Int = 0,
        sound: String? = UILocalNotificationDefaultSoundName,
        occurrence: NSCalendar.Unit? = nil,
        incrementDayIfPast: Bool = true) {
            self.init()
            
            // Initialize and configure notification
            self.category = category
            self.alertBody = body
            self.fireDate = incrementDayIfPast
                ? date.incrementDayIfPast() : date
            
            if let t = title, t != "" {
                self.alertTitle = t
            }
            
            if let s = sound, s != "" {
                self.soundName = s
            }
            
            if let o = occurrence {
                self.repeatInterval = o
            }
            
            // Provide unique identifier for later use
            if let id = identifier, id != "" {
                self.userInfo = [ZamzamConstants.Notification.IDENTIFIER_KEY: id]
            }
        
            // Add arbitrary info
            if let userInfo = userInfo {
                // Initialize dictionary if applicable
                if self.userInfo == nil {
                    self.userInfo = [:]
                }
                
                for item in userInfo {
                    _ = self.userInfo?.updateValue(item.value, forKey: item.key)
                }
            }
            
            if badge > 0 {
                self.applicationIconBadgeNumber = badge
            }
    }
    
}
