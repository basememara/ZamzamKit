//
//  NSBundleTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 3/4/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct BundleTests {
    private let bundle: Bundle = .module
}

extension BundleTests {
    @Test
    func valuesFromText() {
        let values = bundle.string(file: "Test.txt")

        #expect(values == "This is a test. Abc 123.\n")
    }

    @Test
    func dataFromAResource() throws {
        let data = try bundle.data(forResource: "Test", withExtension: "txt", options: .uncached)

        #expect(data.string == "This is a test. Abc 123.\n")
        #expect(throws: (any Error).self) { try bundle.data(forResource: "Missing", withExtension: "txt") }
    }
}
