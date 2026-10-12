//
//  UNUserNotificationCenter.swift
//  ZamzamNotification
//
//  Created by Basem Emara on 2/3/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

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

    /// Retrieve the pending or delivered notification request.
    ///
    /// - Parameters:
    ///   - id: The category for the requests.
    ///   - pendingOnly: Specify to select pending or all requests including delivered.
    func get(withCategory categoryIdentifier: String, pendingOnly: Bool = false) async -> [UNNotificationRequest] {
        await (pendingOnly ? pendingNotificationRequests() : notificationRequests())
            .filter { $0.content.categoryIdentifier == categoryIdentifier }
    }
}

public extension UNUserNotificationCenter {
    /// Determines if the notification request exists.
    ///
    /// - Parameters:
    ///   - id: The identifier for the requests.
    func exists(withIdentifier id: String) async -> Bool {
        await get(withIdentifier: id) != nil
    }

    /// Determines if the notification request exists.
    ///
    /// - Parameters:
    ///   - categoryIdentifier: The category identifier for the requests.
    ///   - pendingOnly: Specify to select pending or all requests including delivered.
    func exists(withCategory categoryIdentifier: String, pendingOnly: Bool = false) async -> Bool {
        await !get(withCategory: categoryIdentifier, pendingOnly: pendingOnly).isEmpty
    }
}

public extension UNUserNotificationCenter {
    /// Schedules a local notification after a time interval, or at once for an interval of zero.
    func add(
        timeInterval: TimeInterval,
        body: String,
        title: String? = nil,
        subtitle: String? = nil,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = .default,
        attachments: [UNNotificationAttachment] = [],
        interruptionLevel: UNNotificationInterruptionLevel? = nil,
        repeats: Bool = false,
        identifier: String = UUID().uuidString,
        category: String = UNUserNotificationCenter.mainCategoryIdentifier,
        userInfo: [String: Any] = [:]
    ) async throws {
        let content = Self.content(
            body: body,
            title: title,
            subtitle: subtitle,
            badge: badge,
            sound: sound,
            attachments: attachments,
            interruptionLevel: interruptionLevel,
            category: category,
            userInfo: userInfo
        )

        let trigger = timeInterval > 0 ? UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats) : nil
        try await add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
    }
}

public extension UNUserNotificationCenter {
    enum ScheduleInterval: Sendable {
        case once
        case minute
        case hour
        case day
        case week
        case month
        case year
    }

    /// Schedules a local notification at a date, once or repeating.
    func add(
        date: Date,
        body: String,
        title: String? = nil,
        subtitle: String? = nil,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = .default,
        attachments: [UNNotificationAttachment] = [],
        interruptionLevel: UNNotificationInterruptionLevel? = nil,
        repeats: ScheduleInterval = .once,
        calendar: Calendar = .current,
        identifier: String = UUID().uuidString,
        category: String = UNUserNotificationCenter.mainCategoryIdentifier,
        userInfo: [String: Any] = [:]
    ) async throws {
        let content = Self.content(
            body: body,
            title: title,
            subtitle: subtitle,
            badge: badge,
            sound: sound,
            attachments: attachments,
            interruptionLevel: interruptionLevel,
            category: category,
            userInfo: userInfo
        )

        let units: Set<Calendar.Component> = switch repeats {
        case .once:
            [.year, .month, .day, .hour, .minute, .second]
        case .minute:
            [.second]
        case .hour:
            [.minute]
        case .day:
            [.hour, .minute]
        case .week:
            [.hour, .minute, .weekday]
        case .month:
            [.hour, .minute, .day]
        case .year:
            [.hour, .minute, .day, .month]
        }

        // Without its calendar and time zone, the trigger reads the components in the device's, which can differ
        let components = calendar.dateComponents(units.union([.calendar, .timeZone]), from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats != .once)
        try await add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
    }
}

#if os(iOS)
public extension UNUserNotificationCenter {
    /// Schedules a local notification for entering or leaving a region.
    func add(
        region: CLRegion,
        body: String,
        title: String? = nil,
        subtitle: String? = nil,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = .default,
        attachments: [UNNotificationAttachment] = [],
        interruptionLevel: UNNotificationInterruptionLevel? = nil,
        repeats: Bool = false,
        identifier: String = UUID().uuidString,
        category: String = UNUserNotificationCenter.mainCategoryIdentifier,
        userInfo: [String: Any] = [:]
    ) async throws {
        let content = Self.content(
            body: body,
            title: title,
            subtitle: subtitle,
            badge: badge,
            sound: sound,
            attachments: attachments,
            interruptionLevel: interruptionLevel,
            category: category,
            userInfo: userInfo
        )

        let trigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        try await add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
    }
}
#endif

private extension UNUserNotificationCenter {
    // swiftlint:disable:next function_parameter_count
    static func content(
        body: String,
        title: String?,
        subtitle: String?,
        badge: NSNumber?,
        sound: UNNotificationSound?,
        attachments: [UNNotificationAttachment],
        interruptionLevel: UNNotificationInterruptionLevel?,
        category: String,
        userInfo: [String: Any]
    ) -> UNMutableNotificationContent {
        UNMutableNotificationContent().apply {
            $0.body = body
            $0.categoryIdentifier = category
            $0.title ?= title
            $0.subtitle ?= subtitle
            $0.badge ?= badge
            $0.sound = sound
            $0.interruptionLevel ?= interruptionLevel
            $0.userInfo = userInfo
            $0.attachments = attachments
        }
    }
}

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
        _ = await notificationRequests()
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
        _ = await pendingNotificationRequests()
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
        _ = await deliveredNotifications()
    }
}
