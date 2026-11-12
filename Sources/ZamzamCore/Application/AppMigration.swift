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

/// Runs blocks of code once per app version, such as a data migration after an update.
///
/// The last version handled is kept in user defaults. Versions compare numerically, so "1.10" is later than "1.9".
///
///     let migration = AppMigration()
///
///     migration
///         .performUpdate {
///             print("Runs once after every update.")
///         }
///         .perform(forVersion: "1.7") {
///             print("Runs once, the first time version 1.7 or later launches.")
///         }
public class AppMigration {
    /// The user defaults suite that holds the saved versions when no other store is given.
    public static let suiteName = "io.zamzam.ZamzamKit.Migration"

    private let defaults: UserDefaults
    private let bundle: Bundle

    private lazy var appVersion: String = bundle
        .infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

    /// Creates a migration that saves its versions in `userDefaults` and reads the app version from `bundle`.
    public init(userDefaults: UserDefaults = UserDefaults(suiteName: suiteName) ?? .standard, bundle: Bundle = .main) {
        self.defaults = userDefaults
        self.bundle = bundle
    }
}

public extension AppMigration {
    /// Runs `completion` when the app version differs from the one saved by the last call, then saves it.
    ///
    /// The first launch counts as a difference.
    @discardableResult
    func performUpdate(completion: () -> Void) -> Self {
        guard lastAppVersion != appVersion else { return self }
        completion()
        lastAppVersion = appVersion
        return self
    }

    /// Runs `completion` once for `version`, when it is later than the last version run and no later than the app version.
    ///
    /// Call it for versions in ascending order: a version at or below the last one run is skipped.
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

    /// Forgets the saved versions, so every block runs again on the next call.
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
