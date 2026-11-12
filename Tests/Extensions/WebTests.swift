//
//  WebHelperTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct WebTests {
}

extension WebTests {
    @Test
    func decodeHTML() {
        let value = "<strong> 4 &lt; 5 &amp; 3 &gt; 2 .</strong> Price: 12 &#x20ac;.  &#64;"
        let newValue = value.htmlDecoded()
        let expectedValue = "<strong> 4 < 5 & 3 > 2 .</strong> Price: 12 €.  @"
        #expect(newValue == expectedValue)
    }
}
