//
//  ApplyTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct ApplyTests {
    @Test
    func apply() {
        let model = SomeModel().apply {
            $0.propertyA = "abc"
            $0.propertyB = 5
            $0.propertyC = true
        }

        #expect(model.propertyA == "abc")
        #expect(model.propertyB == 5)
        #expect(model.propertyC == true)
    }
}

private extension ApplyTests {
    class SomeModel: Apply {
        var propertyA: String?
        var propertyB: Int?
        var propertyC: Bool?
    }
}
