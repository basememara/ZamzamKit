//
//  UNUserNotificationCenter.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/3/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UserNotifications
import CoreLocation

@available(iOS 10, *)
public extension UNUserNotificationCenter {
    
    /// Registers your app’s notification types and the custom actions that they support.
    ///
    /// - Parameters:
    ///   - category: The category identifier.
    ///   - actions: The actions for the category.
    ///   - authorizations: The authorization options.
    func register(
        delegate: UNUserNotificationCenterDelegate? = nil,
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        actions: [UNNotificationAction]? = nil,
        authorizations: UNAuthorizationOptions? = [.alert, .badge, .sound]) {
            register(delegate: delegate, categories: [category: actions], authorizations: authorizations)
    }
    
    /// Registers your app’s notification types and the custom actions that they support.
    ///
    /// - Parameters:
    ///   - category: The category identifier.
    ///   - actions: The actions for the category.
    ///   - authorizations: The authorization options.
    func register(
        delegate: UNUserNotificationCenterDelegate? = nil,
        categories: [String: [UNNotificationAction]?],
        authorizations: UNAuthorizationOptions? = [.alert, .badge, .sound]) {
            self.delegate = delegate

            let categorySet = Set(categories.map {
                UNNotificationCategory(identifier: $0.key, actions: $0.value ?? [], intentIdentifiers: [])
            })
        
            // Request or skip authorization request
            guard let authorizations = authorizations else {
                return getNotificationCategories {
                    guard categorySet != $0 else { return }
                    self.setNotificationCategories(categorySet)
                }
            }
        
            getNotificationSettings {
                guard $0.authorizationStatus == .notDetermined else {
                    // Register category if applicable
                    return self.getNotificationCategories {
                        guard categorySet != $0 else { return }
                        self.setNotificationCategories(categorySet)
                    }
                }
                
                // Request permission before registering if applicable
                return self.requestAuthorization(options: authorizations) {
                    guard $0.0 else { return }
                    self.setNotificationCategories(categorySet)
                }
            }
    }
}

@available(iOS 10, *)
public extension UNUserNotificationCenter {
    
    /// Retrieve the pending notification request.
    ///
    /// - Parameters:
    ///   - withIdentifier: The identifier for the requests.
    ///   - complete: The completion block that will return the request with the identifier.
    func get(withIdentifier: String, complete: @escaping (UNNotificationRequest?) -> Void) {
        getPendingNotificationRequests {
            complete($0.first { $0.identifier == withIdentifier })
        }
    }
    
    /// Retrieve the pending notification requests.
    ///
    /// - Parameters:
    ///   - withIdentifiers: The identifiers for the requests.
    ///   - complete: The completion block that will return the requests with the identifiers.
    func get(withIdentifiers: [String], complete: @escaping ([UNNotificationRequest]) -> Void) {
        getPendingNotificationRequests {
            complete($0.filter { withIdentifiers.contains($0.identifier) })
        }
    }
    
    /// Determines if the pending notification request exists.
    ///
    /// - Parameters:
    ///   - withIdentifier: The identifier for the requests.
    ///   - complete: The completion block that will return the request with the identifier.
    func exists(withIdentifier: String, complete: @escaping (Bool) -> Void) {
        get(withIdentifier: withIdentifier) { complete($0 != nil) }
    }

}

@available(iOS 10, *)
public extension UNUserNotificationCenter {

    /// Schedules a local notification for delivery.
    ///
    /// - Parameters:
    ///   - timeInterval: The time interval of when to fire the notification.
    func add(
        body: String,
        title: String? = nil,
        subtitle: String? = nil,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = UNNotificationSound.default(),
        attachments: [UNNotificationAttachment]? = nil,
        timeInterval: TimeInterval = 0,
        repeats: Bool = false,
        identifier: String = UUID().uuidString,
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        userInfo: [String: Any]? = nil,
        completion: ((Error?) -> Void)? = nil) {
            // Constuct content
            let content: UNMutableNotificationContent = {
                $0.body = body
                $0.categoryIdentifier = category
            
                // Assign optional values to content
                if let title = title { $0.title = title }
                if let subtitle = subtitle { $0.subtitle = subtitle }
                if let badge = badge { $0.badge = badge }
                if let sound = sound { $0.sound = sound }
                if let userInfo = userInfo { $0.userInfo = userInfo }
                if let attachments = attachments, !attachments.isEmpty { $0.attachments = attachments }
                
                return $0
            }(UNMutableNotificationContent())
        
            // Construct request with trigger
            let trigger = timeInterval > 0 ? UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats) : nil
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
            add(request, withCompletionHandler: completion)
    }
    
    /// Schedules a local notification for delivery.
    ///
    /// - Parameters:
    ///   - date: The date of when to fire the notification.
    func add(date: Date,
        body: String,
        title: String? = nil,
        subtitle: String? = nil,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = UNNotificationSound.default(),
        attachments: [UNNotificationAttachment]? = nil,
        repeats: ScheduleInterval = .once,
        identifier: String = UUID().uuidString,
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        userInfo: [String: Any]? = nil,
        completion: ((Error?) -> Void)? = nil) {
            // Constuct content
            let content: UNMutableNotificationContent = {
                $0.body = body
                $0.categoryIdentifier = category
            
                // Assign optional values to content
                if let title = title { $0.title = title }
                if let subtitle = subtitle { $0.subtitle = subtitle }
                if let badge = badge { $0.badge = badge }
                if let sound = sound { $0.sound = sound }
                if let userInfo = userInfo { $0.userInfo = userInfo }
                if let attachments = attachments, !attachments.isEmpty { $0.attachments = attachments }
                
                return $0
            }(UNMutableNotificationContent())
        
            // Constuct date components for trigger
            // https://github.com/d7laungani/DLLocalNotifications/blob/master/DLLocalNotifications/DLLocalNotifications.swift#L31
            let components: DateComponents
            switch repeats {
            case .once: components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            case .minute: components = Calendar.current.dateComponents([.second], from: date)
            case .hour: components = Calendar.current.dateComponents([.minute], from: date)
            case .day: components = Calendar.current.dateComponents([.hour, .minute], from: date)
            case .week: components = Calendar.current.dateComponents([.hour, .minute, .weekday], from: date)
            case .month: components = Calendar.current.dateComponents([.hour, .minute, .day], from: date)
            case .year: components = Calendar.current.dateComponents([.hour, .minute, .day, .month], from: date)
            }
        
            // Construct request with trigger
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats != .once)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
            add(request, withCompletionHandler: completion)
    }
    
    /// Schedules a local notification for delivery.
    ///
    /// - Parameters:
    ///   - region: The region of when to fire the notification.
    func add(region: CLRegion,
        body: String,
        title: String? = nil,
        subtitle: String? = nil,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = UNNotificationSound.default(),
        attachments: [UNNotificationAttachment]? = nil,
        repeats: Bool = false,
        identifier: String = UUID().uuidString,
        category: String = ZamzamConstants.Notification.MAIN_CATEGORY,
        userInfo: [String: Any]? = nil,
        completion: ((Error?) -> Void)? = nil) {
            // Constuct content
            let content: UNMutableNotificationContent = {
                $0.body = body
                $0.categoryIdentifier = category
            
                // Assign optional values to content
                if let title = title { $0.title = title }
                if let subtitle = subtitle { $0.subtitle = subtitle }
                if let badge = badge { $0.badge = badge }
                if let sound = sound { $0.sound = sound }
                if let userInfo = userInfo { $0.userInfo = userInfo }
                if let attachments = attachments, !attachments.isEmpty { $0.attachments = attachments }
                
                return $0
            }(UNMutableNotificationContent())
        
            // Construct request with trigger
            let trigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
            add(request, withCompletionHandler: completion)
    }

}

@available(iOS 10, *)
public extension UNUserNotificationCenter {
    
    /// Remove pending or delivered user notifications.
    ///
    /// - Parameter withIdentifier: The identifier of the user notification to remove.
    func remove(withIdentifier: String) {
        remove(withIdentifiers: [withIdentifier])
    }
    
    /// Remove pending and delivered user notifications.
    ///
    /// - Parameter withIdentifiers: The identifiers of the user notifications to remove.
    ///     If identifiers is nil, all user notifications will be removed.
    func remove(withIdentifiers: [String]? = nil) {
        guard let ids = withIdentifiers, !ids.isEmpty else {
            removeAllPendingNotificationRequests()
            removeAllDeliveredNotifications()
            return
        }
        
        removePendingNotificationRequests(withIdentifiers: ids)
        removeDeliveredNotifications(withIdentifiers: ids)
    }

}
