//
//  MigrationTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/30/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamKit

class MigrationTests: XCTestCase {

    var migration: Migration!
    
    override func setUp() {
        super.setUp()
        
        migration = Migration(
            userDefaults: UserDefaults(suiteName: "MigrationTests")!,
            bundle: Bundle(for: type(of: self))
        )
        
        migration.reset()
    }
    
    func testMigrationReset() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.perform(forVersion: "0.9") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 0.9 (1)")
        migration.perform(forVersion: "0.9", withBuild: "1") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 1.0")
        migration.perform(forVersion: "1.0") {
            expectation3.fulfill()
        }
        
        migration.reset()
        
        let expectation4 = self.expectation(description: "Expecting block to be run again for version 0.9")
        migration.perform(forVersion: "0.9") {
            expectation4.fulfill()
        }
        
        let expectation5 = self.expectation(description: "Expecting block to be run for version 0.9 (1)")
        migration.perform(forVersion: "0.9", withBuild: "1") {
            expectation5.fulfill()
        }
        
        let expectation6 = self.expectation(description: "Expecting block to be run again for version 1.0")
        migration.perform(forVersion: "1.0") {
            expectation6.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testMigrationChained() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.9")
        let expectation2 = self.expectation(description: "Expecting block to be run for version 0.9 (1)")
        let expectation3 = self.expectation(description: "Expecting block to be run for version 1.0")
        let expectation4 = self.expectation(description: "Expecting block to be run for version 1.0 (0.1)")
        let expectation5 = self.expectation(description: "Expecting block to be run for version 1.0 (1)")
        
        migration
            .perform(forVersion: "0.9") {
                expectation1.fulfill()
            }
            .perform(forVersion: "0.9", withBuild: "1") {
                expectation2.fulfill()
            }
            .perform(forVersion: "1.0") {
                expectation3.fulfill()
            }
            .perform(forVersion: "1.0", withBuild: "0.1") {
                expectation4.fulfill()
            }
            .perform(forVersion: "1.0", withBuild: "1") {
                expectation5.fulfill()
            }
            .perform(forVersion: "1.0", withBuild: "1") {
                XCTFail("Should not execute a block for the same version twice")
            }
        
        waitForAllExpectations()
    }
    
    func testMigrationBuild() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.perform(forVersion: "0.9") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 0.9 (1)")
        migration.perform(forVersion: "0.9", withBuild: "1") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 1.0")
        migration.perform(forVersion: "1.0") {
            expectation3.fulfill()
        }
        
        let expectation4 = self.expectation(description: "Expecting block to be run for version 1.0 (0.1)")
        migration.perform(forVersion: "1.0", withBuild: "0.1") {
            expectation4.fulfill()
        }
        
        let expectation5 = self.expectation(description: "Expecting block to be run for version 1.0 (1)")
        migration.perform(forVersion: "1.0", withBuild: "1") {
            expectation5.fulfill()
        }
        
        migration.perform(forVersion: "1.0", withBuild: "1") {
            XCTFail("Should not execute a block for the same version twice")
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesOnFirstRun() {
        let expectation = self.expectation(description: "Should execute migration after reset")
        
        migration.perform(forVersion: "1.0") {
            expectation.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesOnce() {
        let expectation = self.expectation(description: "Expecting block to be run")
        migration.perform(forVersion: "0.9") {
            expectation.fulfill()
        }
        
        migration.perform(forVersion: "0.9") {
            XCTFail("Should not execute a block for the same version twice")
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run")
        migration.perform(forVersion: "1.0", withBuild: "1") {
            expectation2.fulfill()
        }
        
        migration.perform(forVersion: "1.0", withBuild: "1") {
            XCTFail("Should not execute a block for the same version twice")
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesPreviousVersionBlocks() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.perform(forVersion: "0.9") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 1.0")
        migration.perform(forVersion: "1.0") {
            expectation2.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesVersionInNaturalSortOrder() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.perform(forVersion: "0.9") {
            expectation1.fulfill()
        }
        
        migration.perform(forVersion: "0.1") {
            XCTFail("Should use natural sort order, e.g. treat 0.10 as a follower of 0.9")
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 0.10")
        migration.perform(forVersion: "0.10") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 1")
        migration.perform(forVersion: "1") {
            expectation3.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesPreviousBuildsBlocks() {
        let expectation1 = self.expectation(description: "Expecting block to be run for build 0.9")
        migration.perform(forVersion: "1.0", withBuild: "0.9") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for build 1")
        migration.perform(forVersion: "1.0", withBuild: "1") {
            expectation2.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesBuildsInNaturalSortOrder() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 1.0 (0.9)")
        migration.perform(forVersion: "1.0", withBuild: "0.9") {
            expectation1.fulfill()
        }
        
        migration.perform(forVersion: "1.0", withBuild: "0.1") {
            XCTFail("Should use natural sort order, e.g. treat 0.10 as a follower of 0.9")
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 1.0 (0.10)")
        migration.perform(forVersion: "1.0", withBuild: "0.10") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 1 (1)")
        migration.perform(forVersion: "1.0", withBuild: "1") {
            expectation3.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testRunsApplicationUpdateBlockOnce() {
        let expectation = self.expectation(description: "Should only call block once")
        
        migration.performUpdate {
            expectation.fulfill()
        }
        
        migration.performUpdate {
            XCTFail("Expected applicationUpdate to be called only once")
        }
        
        waitForAllExpectations()
    }
    
    func testRunsApplicationUpdateBlockOnlyOnceWithMultipleMigrations() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.8")
        migration.perform(forVersion: "0.8") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.perform(forVersion: "0.9") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 0.10")
        migration.perform(forVersion: "0.10") {
            expectation3.fulfill()
        }
        
        let expectation4 = self.expectation(description: "Should call the applicationUpdate only once no matter how many migrations have to be done")
        migration.performUpdate {
            expectation4.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testRunsBuildUpdateUpdateBlockOnlyOnceWithMultipleMigrations() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.8")
        migration.perform(forVersion: "1.0", withBuild: "0.8") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.perform(forVersion: "1.0", withBuild: "0.9") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 0.10")
        migration.perform(forVersion: "1.0", withBuild: "0.10") {
            expectation3.fulfill()
        }
        
        let expectation4 = self.expectation(description: "Should call the buildNumberUpdate only once no matter how many migrations have to be done")
        migration.performUpdate {
            expectation4.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func waitForAllExpectations() {
        waitForExpectations(timeout: 5) {
            guard let error = $0 else { return }
            print("waitForAllExpectations timeout: \(error)")
        }
    }
    
}
