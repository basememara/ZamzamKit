//
//  UNUserNotificationCenter.swift
//  ZamzamNotification
//
//  Created by Basem Emara on 2/3/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import CoreLocation
import UserNotifications
import ZamzamCore

public extension UNUserNotificationCenter {
    /// Returns the app's ability to schedule and receive local and remote notifications.
    func authorizationStatus() async -> UNAuthorizationStatus {
        await notificationSettings().authorizationStatus
    }
}

public extension UNUserNotificationCenter {
    /// The category a notification gets when none is named.
    static let mainCategoryIdentifier = "mainCategory"

    /// Asks for notification permission and registers one category with its actions.
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
    ///         ]
    ///     )
    ///
    /// The category replaces the center's whole set, as in `register(delegate:categories:authorizations:)`.
    ///
    /// - Returns: Whether the user granted permission.
    func register(
        delegate: UNUserNotificationCenterDelegate? = nil,
        category: String = UNUserNotificationCenter.mainCategoryIdentifier,
        actions: [UNNotificationAction]? = nil,
        authorizations: UNAuthorizationOptions = [.alert, .badge, .sound]
    ) async -> Bool {
        await register(delegate: delegate, categories: [category: actions], authorizations: authorizations)
    }

    /// Asks for notification permission and registers categories with their actions.
    ///
    ///     let granted = await UNUserNotificationCenter.current().register(
    ///         delegate: self,
    ///         categories: [
    ///             "order": [
    ///                 UNNotificationAction(identifier: "confirmAction", title: "Confirm", options: [.foreground])
    ///             ],
    ///             "offer": nil
    ///         ]
    ///     )
    ///
    /// The categories replace the center's whole set when they differ from it. A `nil` delegate leaves the current one.
    ///
    /// - Returns: Whether the user granted permission. When the request itself fails, `true` unless the status is denied.
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
    /// Returns the request of every pending notification, followed by that of every delivered one.
    func notificationRequests() async -> [UNNotificationRequest] {
        await (pendingNotificationRequests() + deliveredNotifications().map(\.request))
    }

    /// Returns the pending or delivered request with the identifier, or `nil` when there is none.
    func get(withIdentifier id: String) async -> UNNotificationRequest? {
        await notificationRequests().first { $0.identifier == id }
    }

    /// Returns the pending and delivered requests with any of the identifiers.
    func get(withIdentifiers ids: [String]) async -> [UNNotificationRequest] {
        await notificationRequests().filter { ids.contains($0.identifier) }
    }

    /// Returns the requests in the category: pending and delivered, or pending alone with `pendingOnly`.
    func get(withCategory categoryIdentifier: String, pendingOnly: Bool = false) async -> [UNNotificationRequest] {
        await (pendingOnly ? pendingNotificationRequests() : notificationRequests())
            .filter { $0.content.categoryIdentifier == categoryIdentifier }
    }
}

public extension UNUserNotificationCenter {
    /// Returns whether a pending or delivered request has the identifier.
    func exists(withIdentifier id: String) async -> Bool {
        await get(withIdentifier: id) != nil
    }

    /// Returns whether a request is in the category: pending or delivered, or pending alone with `pendingOnly`.
    func exists(withCategory categoryIdentifier: String, pendingOnly: Bool = false) async -> Bool {
        await !get(withCategory: categoryIdentifier, pendingOnly: pendingOnly).isEmpty
    }
}

public extension UNUserNotificationCenter {
    /// Schedules a local notification after a time interval, or at once for an interval of zero.
    ///
    /// - Throws: `ZamzamError.invalidData` when `repeats` is set with an interval under a minute, the shortest
    ///   the system repeats.
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

        let trigger = try Self.trigger(after: timeInterval, repeats: repeats)
        try await add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
    }
}

extension UNUserNotificationCenter {
    /// The trigger for a notification due after `timeInterval`, or `nil` for one due at once.
    ///
    /// - Throws: `ZamzamError.invalidData` for a repeating interval under a minute, which the system raises an
    ///   exception for.
    static func trigger(after timeInterval: TimeInterval, repeats: Bool) throws -> UNTimeIntervalNotificationTrigger? {
        guard timeInterval > 0 else { return nil }
        guard !repeats || timeInterval >= 60 else { throw ZamzamError.invalidData }
        return UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
    }
}

public extension UNUserNotificationCenter {
    /// How often a repeating notification fires.
    enum ScheduleInterval: Sendable {
        /// Every minute, at the date's second.
        case minute
        /// Every hour, at the date's minute.
        case hour
        /// Every day, at the date's hour and minute.
        case day
        /// Every week, on the date's weekday at its hour and minute.
        case week
        /// Every month, on the date's day of the month at its hour and minute.
        case month
        /// Every year, on the date's month and day at its hour and minute.
        case year
    }

    /// Schedules a local notification once, at the date itself.
    func add(
        date: Date,
        body: String,
        title: String? = nil,
        subtitle: String? = nil,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = .default,
        attachments: [UNNotificationAttachment] = [],
        interruptionLevel: UNNotificationInterruptionLevel? = nil,
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

        let trigger = UNCalendarNotificationTrigger(date: date)
        try await add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
    }

    /// Schedules a local notification that repeats at the date's wall-clock time in `calendar`.
    func add(
        date: Date,
        repeats: ScheduleInterval,
        calendar: Calendar,
        body: String,
        title: String? = nil,
        subtitle: String? = nil,
        badge: NSNumber? = nil,
        sound: UNNotificationSound? = .default,
        attachments: [UNNotificationAttachment] = [],
        interruptionLevel: UNNotificationInterruptionLevel? = nil,
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

        let trigger = UNCalendarNotificationTrigger(date: date, repeats: repeats, calendar: calendar)
        try await add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
    }
}

extension UNCalendarNotificationTrigger {
    /// A trigger that fires once, at `date`.
    convenience init(date: Date) {
        // A single instant is named in UTC, where no hour repeats when clocks go back. Without its calendar and
        // time zone, the trigger reads the components in the device's, which can differ.
        let calendar = Calendar(identifier: .gregorian, timeZone: .gmt)
        let units: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second, .calendar, .timeZone]
        self.init(dateMatching: calendar.dateComponents(units, from: date), repeats: false)
    }

    /// A trigger that repeats at the wall-clock time of `date` in `calendar`.
    convenience init(date: Date, repeats: UNUserNotificationCenter.ScheduleInterval, calendar: Calendar) {
        let units: Set<Calendar.Component> = switch repeats {
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

        let components = calendar.dateComponents(units.union([.calendar, .timeZone]), from: date)
        self.init(dateMatching: components, repeats: true)
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
    /// Removes the pending and delivered notifications with the identifier.
    func remove(withIdentifier id: String) {
        remove(withIdentifiers: [id])
    }

    /// Removes the pending and delivered notifications with any of the identifiers.
    func remove(withIdentifiers ids: [String]) {
        guard !ids.isEmpty else { return }
        removePendingNotificationRequests(withIdentifiers: ids)
        removeDeliveredNotifications(withIdentifiers: ids)
    }

    /// Removes the pending and delivered notifications in the category.
    func remove(withCategory category: String) async {
        await remove(withCategories: [category])
    }

    /// Removes the pending and delivered notifications in any of the categories.
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
    /// Removes the pending notifications in the category.
    func removePending(withCategory category: String) async {
        await removePending(withCategories: [category])
    }

    /// Removes the pending notifications in any of the categories.
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
    /// Removes the delivered notifications in the category.
    func removeDelivered(withCategory category: String) async {
        await removeDelivered(withCategories: [category])
    }

    /// Removes the delivered notifications in any of the categories.
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
