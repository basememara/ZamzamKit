//
//  AppMigration.swift
//  ZamzamCore
//
//  Inspired by: https://github.com/mysterioustrousers/MTMigration
//
//  Created by Basem Emara on 5/30/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation.NSUserDefaults

/// Manages blocks of code that only need to run once on version updates in apps.
///
///     @UIApplicationMain
///     class AppDelegate: UIResponder, UIApplicationDelegate {
///
///         var window: UIWindow?
///         let migration = Migration()
///
///         func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
///             migration
///                 .performUpdate {
///                     print("Migrate update occurred.")
///                 }
///                 .perform(forVersion: "1.0") {
///                     print("Migrate to 1.0 occurred.")
///                 }
///                 .perform(forVersion: "1.7") {
///                     print("Migrate to 1.7 occurred.")
///                 }
///                 .perform(forVersion: "2.4") {
///                     print("Migrate to 2.4 occurred.")
///                 }
///
///             return true
///         }
///     }
public class AppMigration {
    public static let suiteName = "io.zamzam.ZamzamKit.Migration"

    private let defaults: UserDefaults
    private let bundle: Bundle

    private lazy var appVersion: String = bundle
        .infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

    public init(userDefaults: UserDefaults = UserDefaults(suiteName: suiteName) ?? .standard, bundle: Bundle = .main) {
        self.defaults = userDefaults
        self.bundle = bundle
    }
}

public extension AppMigration {

    /// Checks the current version of the app against the previous saved version.
    ///
    /// - Parameter completion: Will be called when the app is updated. Will always be called once.
    @discardableResult
    func performUpdate(completion: () -> Void) -> Self {
        guard lastAppVersion != appVersion else { return self }
        completion()
        lastAppVersion = appVersion
        return self
    }

    /// Checks the current version of the app against the previous saved version.
    /// If it doesn't match the completion block gets called, and passed in the current app verson.
    ///
    /// - Parameters:
    ///   - version: Version to update.
    ///   - build: Build to update.
    ///   - completion: Will be called when the app is updated. Will always be called once.
    @discardableResult
    func perform(forVersion version: String, completion: () -> Void) -> Self {
        guard version.compare(lastMigrationVersion ?? "", options: .numeric) == .orderedDescending,
            version.compare(appVersion, options: .numeric) != .orderedDescending else {
                return self
        }

        completion()
        lastMigrationVersion = version
        return self
    }

    /// Wipe saved values when last migrated so next update will occur.
    func reset() {
        lastAppVersion = nil
        lastMigrationVersion = nil
    }
}

private extension AppMigration {
    private static let lastAppVersionKey = "lastAppVersion"
    private static let lastVersionKey = "lastMigrationVersion"

    var lastAppVersion: String? {
        get { defaults.string(forKey: Self.lastAppVersionKey) }
        set { defaults.setValue(newValue, forKey: Self.lastAppVersionKey) }
    }

    var lastMigrationVersion: String? {
        get { defaults.string(forKey: Self.lastVersionKey) }
        set { defaults.setValue(newValue, forKey: Self.lastVersionKey) }
    }
}

// MARK: - Only used for XCTest

extension AppMigration {

    func set(version: String) {
        appVersion = version
    }
}
