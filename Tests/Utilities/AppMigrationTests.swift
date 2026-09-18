//
//  AppMigrationTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 5/30/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
@testable import ZamzamCore

struct AppMigrationTests {
}

extension AppMigrationTests {
    @Test
    func migrationReset() throws {
        let migration: AppMigration = try .makeMigration(forVersion: "1.0")

        var ran1 = false
        migration.perform(forVersion: "0.9") { ran1 = true }
        #expect(ran1, "Expecting block to be run for version 0.9")

        var ran3 = false
        migration.perform(forVersion: "1.0") { ran3 = true }
        #expect(ran3, "Expecting block to be run for version 1.0")

        migration.reset()

        var ran4 = false
        migration.perform(forVersion: "0.9") { ran4 = true }
        #expect(ran4, "Expecting block to be run again for version 0.9")

        var ran6 = false
        migration.perform(forVersion: "1.0") { ran6 = true }
        #expect(ran6, "Expecting block to be run again for version 1.0")
    }
}

extension AppMigrationTests {
    @Test
    func migrationChained() throws {
        let migration: AppMigration = try .makeMigration(forVersion: "1.0")

        var ran1 = false
        var ran2 = false

        migration
            .perform(forVersion: "0.9") {
                ran1 = true
            }
            .perform(forVersion: "0.9") {
                Issue.record("Should not execute a block for the same version twice")
            }
            .perform(forVersion: "1.0") {
                ran2 = true
            }
            .perform(forVersion: "1.0") {
                Issue.record("Should not execute a block for the same version twice")
            }
            .perform(forVersion: "2.0") {
                Issue.record("Should not execute a block for a future version")
            }

        #expect(ran1)
        #expect(ran2)
    }
}

extension AppMigrationTests {
    @Test
    func migrationBuild() throws {
        let migration: AppMigration = try .makeMigration(forVersion: "1.0")

        var ran1 = false
        migration.perform(forVersion: "0.9") { ran1 = true }
        #expect(ran1, "Expecting block to be run for version 0.9")

        migration.perform(forVersion: "0.9") {
            Issue.record("Should not execute a block for the same version twice")
        }

        var ran2 = false
        migration.perform(forVersion: "1.0") { ran2 = true }
        #expect(ran2, "Expecting block to be run for version 1.0")

        migration.perform(forVersion: "1.0") {
            Issue.record("Should not execute a block for the same version twice")
        }
    }
}

extension AppMigrationTests {
    @Test
    func migratesOnFirstRun() throws {
        let migration: AppMigration = try .makeMigration(forVersion: "1.1")
        var ran = false

        migration.perform(forVersion: "1.0") {
            ran = true
        }

        #expect(ran)
    }
}

extension AppMigrationTests {
    @Test
    func migratesOnce() throws {
        let migration: AppMigration = try .makeMigration(forVersion: "1.0")

        var ran = false
        migration.perform(forVersion: "0.9") {
            ran = true
        }

        migration.perform(forVersion: "0.9") {
            Issue.record("Should not execute a block for the same version twice")
        }

        var ran2 = false
        migration.perform(forVersion: "1.0") { ran2 = true }
        #expect(ran2, "Expecting block to be run")

        migration.perform(forVersion: "1.0") {
            Issue.record("Should not execute a block for the same version twice")
        }

        #expect(ran)
    }
}

extension AppMigrationTests {
    @Test
    func migratesPreviousVersionBlocks() throws {
        let migration: AppMigration = try .makeMigration(forVersion: "1.0")

        var ran1 = false
        migration.perform(forVersion: "0.9") { ran1 = true }
        #expect(ran1, "Expecting block to be run for version 0.9")

        var ran2 = false
        migration.perform(forVersion: "1.0") { ran2 = true }
        #expect(ran2, "Expecting block to be run for version 1.0")
    }
}

extension AppMigrationTests {
    @Test
    func migratesVersionInNaturalSortOrder() throws {
        let migration: AppMigration = try .makeMigration(forVersion: "1.0")

        var ran1 = false
        migration.perform(forVersion: "0.9") { ran1 = true }
        #expect(ran1, "Expecting block to be run for version 0.9")

        migration.perform(forVersion: "0.1") {
            Issue.record("Should use natural sort order, e.g. treat 0.10 as a follower of 0.9")
        }

        var ran2 = false
        migration.perform(forVersion: "0.10") { ran2 = true }
        #expect(ran2, "Expecting block to be run for version 0.10")

        var ran3 = false
        migration.perform(forVersion: "1") { ran3 = true }
        #expect(ran3, "Expecting block to be run for version 1")
    }
}

extension AppMigrationTests {
    @Test
    func runsApplicationUpdateBlockOnce() throws {
        let migration: AppMigration = try .makeMigration(forVersion: "1.0")
        var ran = false

        migration.performUpdate {
            ran = true
        }

        migration.performUpdate {
            Issue.record("Expected applicationUpdate to be called only once")
        }

        #expect(ran)
    }
}

extension AppMigrationTests {
    @Test
    func runsApplicationUpdateBlockOnlyOnceWithMultipleMigrations() throws {
        let migration: AppMigration = try .makeMigration(forVersion: "1.0")

        var ran1 = false
        migration.perform(forVersion: "0.8") { ran1 = true }
        #expect(ran1, "Expecting block to be run for version 0.8")

        var ran2 = false
        migration.perform(forVersion: "0.9") { ran2 = true }
        #expect(ran2, "Expecting block to be run for version 0.9")

        var ran3 = false
        migration.perform(forVersion: "0.10") { ran3 = true }
        #expect(ran3, "Expecting block to be run for version 0.10")

        var ran4 = false
        migration.performUpdate { ran4 = true }
        #expect(ran4, "Should call the applicationUpdate only once no matter how many migrations have to be done")
    }
}

// MARK: - Helpers


private extension AppMigration {
    static func makeMigration(forVersion version: String) throws -> AppMigration {
        let migration = AppMigration(
            userDefaults: try #require(UserDefaults(suiteName: UUID().uuidString)),
            bundle: .module
        )

        // Simulate build version
        migration.set(version: version)

        migration.reset()

        return migration
    }
}
