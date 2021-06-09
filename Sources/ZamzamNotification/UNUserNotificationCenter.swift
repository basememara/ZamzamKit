//
//  UNUserNotificationCenter.swift
//  ZamzamLocation
//
//  Created by Basem Emara on 2/3/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

#if !os(tvOS)
import UserNotifications
import CoreLocation
import ZamzamCore

public extension UNUserNotificationCenter {
    /// Returns the app's ability to schedule and receive local and remote notifications.
    func authorizationStatus() async -> UNAuthorizationStatus {
        await notificationSettings().authorizationStatus
    }
}

public extension UNUserNotificationCenter {
    static let mainCategoryIdentifier = "mainCategory"

    /// Registers the local and remote notifications with the category and actions it supports.
    ///
    ///     let granted = await UNUserNotificationCenter.current().register(
    ///         delegate: self,
    ///         category: "chat",
    ///         actions: [
    ///             UNTextInputNotificationAction(
    ///                 identifier: "replyAction",
    ///                 title: "Reply",
    ///                 options: [],
    ///                 textInputButtonTitle: "Send",
    ///                 textInputPlaceholder: "Type your message"
    ///             )
    ///         ],
    ///         authorizations: [.alert, .badge, .sound]
    ///     )
    ///
    ///     if granted {
    ///         log.debug("Authorization for notification succeeded.")
    ///     } else {
    ///         log.warn("Authorization for notification not given.")
    ///     }
    ///
    /// - Parameters:
    ///   - delegate: The object that processes incoming notifications and notification-related actions.
    ///   - category: The category identifier. Default is `UNUserNotificationCenter.mainCategoryIdentifier`.
    ///   - actions: The actions for the category.
    ///   - authorizations: Constants for requesting authorization to interact with the user. Default is `[.alert, .badge, .sound]`.
    func register(
        delegate: UNUserNotificationCenterDelegate? = nil,
        category: String = UNUserNotificationCenter.mainCategoryIdentifier,
        actions: [UNNotificationAction]? = nil,
        authorizations: UNAuthorizationOptions = [.alert, .badge, .sound]
    ) async -> Bool {
        await register(delegate: delegate, categories: [category: actions], authorizations: authorizations)
    }

    /// Registers the local and remote notifications with the categories and actions it supports.
    ///
    ///     let granted = await UNUserNotificationCenter.current().register(
    ///         delegate: self,
    ///         categories: [
    ///             "order": [
    ///                 UNNotificationAction(
    ///                     identifier: "confirmAction",
    ///                     title: "Confirm",
    ///                     options: [.foreground]
    ///                 )
    ///             ],
    ///             "chat": [
    ///                 UNTextInputNotificationAction(
    ///                     identifier: "replyAction",
    ///                     title: "Reply",
    ///                     options: [],
    ///                     textInputButtonTitle: "Send",
    ///                     textInputPlaceholder: "Type your message"
    ///                 )
    ///             ],
    ///             "offer": nil
    ///         ],
    ///         authorizations: [.alert, .badge, .sound]
    ///     )
    ///
    ///     if granted {
    ///         log.debug("Authorization for notification succeeded.")
    ///     } else {
    ///         log.warn("Authorization for notification not given.")
    ///     }
    ///
    /// - Parameters:
    ///   - delegate: The object that processes incoming notifications and notification-related actions.
    ///   - categories: The category identifiers and associated actions.
    ///   - authorizations: Constants for requesting authorization to interact with the user. Default is `[.alert, .badge, .sound]`.
    func register(
        delegate: UNUserNotificationCenterDelegate? = nil,
        categories: [String: [UNNotificationAction]?],
        authorizations: UNAuthorizationOptions = [.alert, .badge, .sound]
    ) async -> Bool {
        self.delegate ?= delegate

        let oldCategories = await notificationCategories()
        let newCategories = Set(
            categories.map {
                UNNotificationCategory(
                    identifier: $0.key,
                    actions: $0.value ?? [],
                    intentIdentifiers: [],
                    options: .customDismissAction
                )
            }
        )

        defer {
            if newCategories != oldCategories {
                setNotificationCategories(newCategories)
            }
        }

        do {
            return try await requestAuthorization(options: authorizations)
        } catch {
            return await authorizationStatus() != .denied
        }
    }
}

public extension UNUserNotificationCenter {
    /// Returns a list of all pending or delivered user notifications.
    func notificationRequests() async -> [UNNotificationRequest] {
        await (pendingNotificationRequests() + deliveredNotifications().map(\.request))
    }

    /// Retrieve the pending or delivered notification request.
    ///
    /// - Parameters:
    ///   - id: The identifier for the requests.
    func get(withIdentifier id: String) async -> UNNotificationRequest? {
        await notificationRequests().first { $0.identifier == id }
    }

    /// Retrieve the pending or delivered notification requests.
    ///
    /// - Parameters:
    ///   - ids: The identifiers for the requests.
    func get(withIdentifiers ids: [String]) async -> [UNNotificationRequest] {
        await notificationRequests().filter { ids.contains($0.identifier) }
    }

    /// Determines if the pending notification request exists.
    ///
    /// - Parameters:
    ///   - id: The identifier for the requests.
    func exists(withIdentifier id: String) async -> Bool {
        await get(withIdentifier: id) != nil
    }
}

public extension UNUserNotificationCenter {
    /// Constants that indicate the importance and delivery timing of a notification.
    enum InterruptionLevel {
        /// The system adds the notification to the notification list without lighting up the screen or playing a sound.
        case passive

        /// The system presents the notification immediately, lights up the screen, and can play a sound, but won’t break through system notification controls.
        case timeSensitive
    }

    /// Schedules a local notification for delivery.
    ///
    /// - Parameters:
    ///   - timeInterval: The time interval of when to fire the notification.
    func add(
        body: String,
        title: String? = nil,
        subtitle: String? = nil,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = .default,
        attachments: [UNNotificationAttachment]? = nil,
        timeInterval: TimeInterval = 0,
        interruptionLevel: InterruptionLevel? = nil,
        repeats: Bool = false,
        identifier: String = UUID().uuidString,
        category: String = UNUserNotificationCenter.mainCategoryIdentifier,
        userInfo: [String: Any]? = nil,
        completion: ((Error?) -> Void)? = nil
    ) {
        // Constuct content
        let content = UNMutableNotificationContent().apply {
            $0.body = body
            $0.categoryIdentifier = category

            // Assign optional values to content
            $0.title ?= title
            $0.subtitle ?= subtitle
            $0.badge ?= badge
            $0.sound = sound

            if #available(macOS 12, iOS 15, watchOS 8, tvOS 15, *),
               let interruptionLevel = interruptionLevel {
                switch interruptionLevel {
                case .passive:
                    $0.interruptionLevel = .passive
                case .timeSensitive:
                    $0.interruptionLevel = .timeSensitive
                }
            }

            if let userInfo = userInfo {
                $0.userInfo = userInfo
            }

            if let attachments = attachments, !attachments.isEmpty {
                $0.attachments = attachments
            }
        }

        // Construct request with trigger
        let trigger = timeInterval > 0 ? UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats) : nil
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        add(request, withCompletionHandler: completion)
    }
}

public extension UNUserNotificationCenter {
    enum ScheduleInterval {
        case once
        case minute
        case hour
        case day
        case week
        case month
        case year
    }

    /// Schedules a local notification for delivery.
    ///
    /// - Parameters:
    ///   - date: The date of when to fire the notification.
    func add(
        date: Date,
        body: String,
        title: String? = nil,
        subtitle: String? = nil,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = .default,
        attachments: [UNNotificationAttachment]? = nil,
        interruptionLevel: InterruptionLevel? = nil,
        repeats: ScheduleInterval = .once,
        calendar: Calendar = .current,
        identifier: String = UUID().uuidString,
        category: String = UNUserNotificationCenter.mainCategoryIdentifier,
        userInfo: [String: Any]? = nil,
        completion: ((Error?) -> Void)? = nil
    ) {
        // Constuct content
        let content = UNMutableNotificationContent().apply {
            $0.body = body
            $0.categoryIdentifier = category

            // Assign optional values to content
            $0.title ?= title
            $0.subtitle ?= subtitle
            $0.badge ?= badge
            $0.sound = sound

            if #available(macOS 12, iOS 15, watchOS 8, tvOS 15, *),
               let interruptionLevel = interruptionLevel {
                switch interruptionLevel {
                case .passive:
                    $0.interruptionLevel = .passive
                case .timeSensitive:
                    $0.interruptionLevel = .timeSensitive
                }
            }

            if let userInfo = userInfo {
                $0.userInfo = userInfo
            }

            if let attachments = attachments, !attachments.isEmpty {
                $0.attachments = attachments
            }
        }

        // Constuct date components for trigger
        // https://github.com/d7laungani/DLLocalNotifications/blob/master/DLLocalNotifications/DLLocalNotifications.swift#L31
        let components: DateComponents
        switch repeats {
        case .once:
            components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        case .minute:
            components = calendar.dateComponents([.second], from: date)
        case .hour:
            components = calendar.dateComponents([.minute], from: date)
        case .day:
            components = calendar.dateComponents([.hour, .minute], from: date)
        case .week:
            components = calendar.dateComponents([.hour, .minute, .weekday], from: date)
        case .month:
            components = calendar.dateComponents([.hour, .minute, .day], from: date)
        case .year:
            components = calendar.dateComponents([.hour, .minute, .day, .month], from: date)
        }

        // Construct request with trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats != .once)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        add(request, withCompletionHandler: completion)
    }
}

#if os(iOS)
public extension UNUserNotificationCenter {
    /// Schedules a local notification for delivery.
    ///
    /// - Parameters:
    ///   - region: The region of when to fire the notification.
    func add(
        region: CLRegion,
        body: String,
        title: String? = nil,
        subtitle: String? = nil,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = .default,
        attachments: [UNNotificationAttachment]? = nil,
        interruptionLevel: InterruptionLevel? = nil,
        repeats: Bool = false,
        identifier: String = UUID().uuidString,
        category: String = UNUserNotificationCenter.mainCategoryIdentifier,
        userInfo: [String: Any]? = nil,
        completion: ((Error?) -> Void)? = nil
    ) {
        // Constuct content
        let content = UNMutableNotificationContent().apply {
            $0.body = body
            $0.categoryIdentifier = category

            // Assign optional values to content
            $0.title ?= title
            $0.subtitle ?= subtitle
            $0.badge ?= badge
            $0.sound = sound

            if #available(macOS 12, iOS 15, watchOS 8, tvOS 15, *),
               let interruptionLevel = interruptionLevel {
                switch interruptionLevel {
                case .passive:
                    $0.interruptionLevel = .passive
                case .timeSensitive:
                    $0.interruptionLevel = .timeSensitive
                }
            }

            if let userInfo = userInfo {
                $0.userInfo = userInfo
            }

            if let attachments = attachments, !attachments.isEmpty {
                $0.attachments = attachments
            }
        }

        // Construct request with trigger
        let trigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        add(request, withCompletionHandler: completion)
    }
}
#endif

public extension UNUserNotificationCenter {
    /// Remove pending or delivered user notifications.
    ///
    /// - Parameter id: The identifier of the user notification to remove.
    func remove(withIdentifier id: String) {
        remove(withIdentifiers: [id])
    }

    /// Remove pending and delivered user notifications.
    ///
    /// - Parameter ids: The identifiers of the user notifications to remove.
    func remove(withIdentifiers ids: [String]) {
        guard !ids.isEmpty else { return }
        removePendingNotificationRequests(withIdentifiers: ids)
        removeDeliveredNotifications(withIdentifiers: ids)
    }

    /// Remove pending and delivered user notifications.
    ///
    /// - Parameter withCategory: The category of the user notification to remove.
    func remove(withCategory category: String) async {
        await remove(withCategories: [category])
    }

    /// Remove pending and delivered user notifications.
    ///
    /// - Parameter withCategory: The categories of the user notification to remove.
    func remove(withCategories categories: [String]) async {
        remove(withIdentifiers: await notificationRequests().compactMap {
            categories.contains($0.content.categoryIdentifier) ? $0.identifier : nil
        })

        // Get back in queue since native remove has no completion block
        // https://stackoverflow.com/a/46434645
        let remaining = await notificationRequests()
        assert(remaining.isEmpty, "Notifications should be removed")
    }

    /// Remove all pending and delivered user notifications.
    func removeAll() {
        removeAllPendingNotificationRequests()
        removeAllDeliveredNotifications()
    }
}

public extension UNUserNotificationCenter {
    /// Remove pending user notifications.
    ///
    /// - Parameter withCategory: The category of the user notification to remove.
    func removePending(withCategory category: String) async {
        await removePending(withCategories: [category])
    }

    /// Remove pending user notifications.
    ///
    /// - Parameter withCategory: The categories of the user notification to remove.
    func removePending(withCategories categories: [String]) async {
        removePendingNotificationRequests(
            withIdentifiers: await pendingNotificationRequests().compactMap {
                categories.contains($0.content.categoryIdentifier) ? $0.identifier : nil
            }
        )

        // Get back in queue since native remove has no completion block
        // https://stackoverflow.com/a/46434645
        let remaining = await pendingNotificationRequests()
        assert(remaining.isEmpty, "Notifications should be removed")
    }
}

public extension UNUserNotificationCenter {
    /// Remove delivered user notifications.
    ///
    /// - Parameter withCategory: The category of the user notification to remove.
    func removeDelivered(withCategory category: String) async {
        await removeDelivered(withCategories: [category])
    }

    /// Remove delivered user notifications.
    ///
    /// - Parameter withCategory: The categories of the user notification to remove.
    func removeDelivered(withCategories categories: [String]) async {
        removeDeliveredNotifications(
            withIdentifiers: await deliveredNotifications().compactMap {
                categories.contains($0.request.content.categoryIdentifier) ? $0.request.identifier : nil
            }
        )

        // Get back in queue since native remove has no completion block
        // https://stackoverflow.com/a/46434645
        let remaining = await deliveredNotifications()
        assert(remaining.isEmpty, "Notifications should be removed")
    }
}
#endif
