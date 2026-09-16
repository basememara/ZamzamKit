//
//  LocaleTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 4/19/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct LocaleTests {
    @Test
    func posix() {
        let test: Locale = .posix
        #expect(test.identifier == "en_US_POSIX")
    }
}
