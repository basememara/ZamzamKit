//
//  Migration.swift
//  ZamzamKit
//
//  Inspired by: https://github.com/mysterioustrousers/MTMigration
//
//  Created by Basem Emara on 5/30/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

public class Migration {
    public static let suiteName = "\(ZamzamConstants.bundleNamespace).Migration"
    
    private let defaults: UserDefaults
    private let bundle: Bundle

    private lazy var appVersion: String = bundle
        .infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    private lazy var appBuild: String = bundle
        .infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""

    public init(userDefaults: UserDefaults = UserDefaults(suiteName: suiteName)!, bundle: Bundle = Bundle.main) {
        self.defaults = userDefaults
        self.bundle = bundle
    }
}

public extension Migration {
    
    /// Checks the current version and build of the app against the pervious saved version and build.
    /// If they don't match the completion block gets called, and passed in the current app verson.
    ///
    /// - Parameter completion: Will be called when the app is updated. Will always be called once.
    @discardableResult
    func performUpdate(completion: () -> Void) -> Self {
        guard lastAppVersion != appVersion || lastAppBuild != appBuild else { return self }
        completion()
        lastAppVersion = appVersion
        lastAppBuild = appBuild
        return self
    }
    
    /// Checks the current version and build of the app against the pervious saved version and build.
    /// If they don't match the completion block gets called, and passed in the current app verson.
    ///
    /// - Parameters:
    ///   - version: Version to update.
    ///   - build: Build to update.
    ///   - completion: Will be called when the app is updated. Will always be called once.
    @discardableResult
    func perform(forVersion version: String, withBuild build: String? = nil, completion: () -> Void) -> Self {
        let hasVersionUpdate = version.compare(lastMigrationVersion ?? "", options: .numeric) == .orderedDescending
            && version.compare(appVersion, options: .numeric) != .orderedDescending
        
        let hasBuildUpdate = build != nil
            && (lastMigrationBuild == nil //Allows update build first time
                || (version == appVersion //Ensure comparing build of same version
                    && build?.compare(lastMigrationBuild ?? "", options: .numeric) == .orderedDescending
                    && build?.compare(appBuild, options: .numeric) != .orderedDescending))
        
        guard hasVersionUpdate || hasBuildUpdate else { return self }
        
        completion()
        lastMigrationVersion = version
        lastMigrationBuild = build
        return self
    }
    
    /// Wipe saved values when last migrated so next update will occur.
    func reset() {
        lastAppVersion = nil
        lastAppBuild = nil
        lastMigrationVersion = nil
        lastMigrationBuild = nil
    }
}

private extension Migration {
    private static let lastAppVersionKey = "lastAppVersion"
    private static let lastAppBuildKey = "lastAppBuild"
    private static let lastVersionKey = "lastMigrationVersion"
    private static let lastBuildKey = "lastMigrationBuild"
    
    var lastAppVersion: String? {
        get { return defaults.string(forKey: Migration.lastAppVersionKey) }
        set { defaults.setValue(newValue, forKey: Migration.lastAppVersionKey) }
    }
    
    var lastAppBuild: String? {
        get { return defaults.string(forKey: Migration.lastAppBuildKey) }
        set { defaults.setValue(newValue, forKey: Migration.lastAppBuildKey) }
    }
    
    var lastMigrationVersion: String? {
        get { return defaults.string(forKey: Migration.lastVersionKey) }
        set { defaults.setValue(newValue, forKey: Migration.lastVersionKey) }
    }
    
    var lastMigrationBuild: String? {
        get { return defaults.string(forKey: Migration.lastBuildKey) }
        set { defaults.setValue(newValue, forKey: Migration.lastBuildKey) }
    }
}
