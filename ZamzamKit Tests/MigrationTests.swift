//
//  MigrationTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/30/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import XCTest
@testable import ZamzamKit

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
        migration.appUpdate(toVersion: "0.9") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 0.9 (1)")
        migration.appUpdate(toVersion: "0.9", toBuild: "1") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 1.0")
        migration.appUpdate(toVersion: "1.0") {
            expectation3.fulfill()
        }
        
        migration.reset()
        
        let expectation4 = self.expectation(description: "Expecting block to be run again for version 0.9")
        migration.appUpdate(toVersion: "0.9") {
            expectation4.fulfill()
        }
        
        let expectation5 = self.expectation(description: "Expecting block to be run for version 0.9 (1)")
        migration.appUpdate(toVersion: "0.9", toBuild: "1") {
            expectation5.fulfill()
        }
        
        let expectation6 = self.expectation(description: "Expecting block to be run again for version 1.0")
        migration.appUpdate(toVersion: "1.0") {
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
            .appUpdate(toVersion: "0.9") {
                expectation1.fulfill()
            }
            .appUpdate(toVersion: "0.9", toBuild: "1") {
                expectation2.fulfill()
            }
            .appUpdate(toVersion: "1.0") {
                expectation3.fulfill()
            }
            .appUpdate(toVersion: "1.0", toBuild: "0.1") {
                expectation4.fulfill()
            }
            .appUpdate(toVersion: "1.0", toBuild: "1") {
                expectation5.fulfill()
            }
            .appUpdate(toVersion: "1.0", toBuild: "1") {
                XCTFail("Should not execute a block for the same version twice")
            }
        
        waitForAllExpectations()
    }
    
    func testMigrationBuild() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.appUpdate(toVersion: "0.9") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 0.9 (1)")
        migration.appUpdate(toVersion: "0.9", toBuild: "1") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 1.0")
        migration.appUpdate(toVersion: "1.0") {
            expectation3.fulfill()
        }
        
        let expectation4 = self.expectation(description: "Expecting block to be run for version 1.0 (0.1)")
        migration.appUpdate(toVersion: "1.0", toBuild: "0.1") {
            expectation4.fulfill()
        }
        
        let expectation5 = self.expectation(description: "Expecting block to be run for version 1.0 (1)")
        migration.appUpdate(toVersion: "1.0", toBuild: "1") {
            expectation5.fulfill()
        }
        
        migration.appUpdate(toVersion: "1.0", toBuild: "1") {
            XCTFail("Should not execute a block for the same version twice")
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesOnFirstRun() {
        let expectation = self.expectation(description: "Should execute migration after reset")
        migration.appUpdate(toVersion: "1.0") {
            expectation.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesOnce() {
        let expectation = self.expectation(description: "Expecting block to be run")
        migration.appUpdate(toVersion: "0.9") {
            expectation.fulfill()
        }
        
        migration.appUpdate(toVersion: "0.9") {
            XCTFail("Should not execute a block for the same version twice")
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run")
        migration.appUpdate(toVersion: "1.0", toBuild: "1") {
            expectation2.fulfill()
        }
        
        migration.appUpdate(toVersion: "1.0", toBuild: "1") {
            XCTFail("Should not execute a block for the same version twice")
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesPreviousVersionBlocks() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.appUpdate(toVersion: "0.9") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 1.0")
        migration.appUpdate(toVersion: "1.0") {
            expectation2.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesVersionInNaturalSortOrder() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.appUpdate(toVersion: "0.9") {
            expectation1.fulfill()
        }
        
        migration.appUpdate(toVersion: "0.1") {
            XCTFail("Should use natural sort order, e.g. treat 0.10 as a follower of 0.9")
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 0.10")
        migration.appUpdate(toVersion: "0.10") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 1")
        migration.appUpdate(toVersion: "1") {
            expectation3.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesPreviousBuildsBlocks() {
        let expectation1 = self.expectation(description: "Expecting block to be run for build 0.9")
        migration.appUpdate(toVersion: "1.0", toBuild: "0.9") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for build 1")
        migration.appUpdate(toVersion: "1.0", toBuild: "1") {
            expectation2.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesBuildsInNaturalSortOrder() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 1.0 (0.9)")
        migration.appUpdate(toVersion: "1.0", toBuild: "0.9") {
            expectation1.fulfill()
        }
        
        migration.appUpdate(toVersion: "1.0", toBuild: "0.1") {
            XCTFail("Should use natural sort order, e.g. treat 0.10 as a follower of 0.9")
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 1.0 (0.10)")
        migration.appUpdate(toVersion: "1.0", toBuild: "0.10") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 1 (1)")
        migration.appUpdate(toVersion: "1.0", toBuild: "1") {
            expectation3.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testRunsApplicationUpdateBlockOnce() {
        let expectation = self.expectation(description: "Should only call block once")
        migration.appUpdate {
            expectation.fulfill()
        }
        
        migration.appUpdate {
            XCTFail("Expected applicationUpdate to be called only once")
        }
        
        waitForAllExpectations()
    }
    
    func testRunsApplicationUpdateBlockOnlyOnceWithMultipleMigrations() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.8")
        migration.appUpdate(toVersion: "0.8") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.appUpdate(toVersion: "0.9") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 0.10")
        migration.appUpdate(toVersion: "0.10") {
            expectation3.fulfill()
        }
        
        let expectation4 = self.expectation(description: "Should call the applicationUpdate only once no matter how many migrations have to be done")
        migration.appUpdate {
            expectation4.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testRunsBuildUpdateUpdateBlockOnlyOnceWithMultipleMigrations() {
        let expectation1 = self.expectation(description: "Expecting block to be run for version 0.8")
        migration.appUpdate(toVersion: "1.0", toBuild: "0.8") {
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectation(description: "Expecting block to be run for version 0.9")
        migration.appUpdate(toVersion: "1.0", toBuild: "0.9") {
            expectation2.fulfill()
        }
        
        let expectation3 = self.expectation(description: "Expecting block to be run for version 0.10")
        migration.appUpdate(toVersion: "1.0", toBuild: "0.10") {
            expectation3.fulfill()
        }
        
        let expectation4 = self.expectation(description: "Should call the buildNumberUpdate only once no matter how many migrations have to be done")
        migration.appUpdate {
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
