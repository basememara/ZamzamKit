//
//  BinaryFloatingPointTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 5/14/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct BinaryFloatingPointTests {
    @Test
    func rounded() {
        let test1: Float = 123.12312421
        #expect(test1.rounded(toPlaces: 2) == 123.12)

        let test2: Float = -976.23238798652
        #expect(test2.rounded(toPlaces: 8) == -976.2323880)

        let test3: Float = 123.1
        #expect(test3.rounded(toPlaces: 2) == 123.1)

        let test4: Double = 2341.32523
        #expect(test4.rounded(toPlaces: 2) == 2341.33)

        let test5: Double = 2341.3252323423
        #expect(test5.rounded(toPlaces: 6) == 2341.325232)

        let test6: Double = 234
        #expect(test6.rounded(toPlaces: 2) == 234)

        #expect(Double.pi.rounded(toPlaces: 2) == 3.14)
    }
}
