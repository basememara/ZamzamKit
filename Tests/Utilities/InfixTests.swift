//
//  InfixTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 4/22/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct InfixTests {
    @Test
    func conditionalAssign() {
        var someProperty = "abc"
        var someValue: String?

        someProperty ?= someValue
        #expect(someProperty == "abc")

        someValue = "xyz"
        someProperty ?= someValue
        #expect(someProperty == "xyz")

        var test: Int? = 123
        var value: Int?

        test ?= value
        #expect(test == 123)

        value = 456
        test ?= value
        #expect(test == 456)
    }
}
