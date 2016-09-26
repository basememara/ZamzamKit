//
//  UILocalNotification.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import UIKit

public extension UILocalNotification {
    
    public convenience init(
        date: Date,
        body: String,
        title: String? = nil,
        identifier: String? = nil,
        userInfo: [String: AnyObject]? = nil,
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
                    self.userInfo?.updateValue(item.1, forKey: item.0)
                }
            }
            
            if badge > 0 {
                self.applicationIconBadgeNumber = badge
            }
    }
    
}
