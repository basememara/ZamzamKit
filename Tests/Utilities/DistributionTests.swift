//
//  DistributionTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2026-11-18.
//  Copyright © 2026 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
@testable import ZamzamCore

struct DistributionTests {
    @Test func aSandboxReceiptIsTestFlights() {
        let receipt = Data([0x30, 0x80, 0x0C, 0x11]) + Data("ProductionSandbox".utf8) + Data([0x30, 0x14])
        #expect(isSandboxReceipt(receipt))
    }

    @Test func aProductionReceiptIsTheAppStores() {
        let receipt = Data([0x30, 0x80, 0x0C, 0x0A]) + Data("Production".utf8) + Data([0x30, 0x14])
        #expect(!isSandboxReceipt(receipt))
    }
}
