//
//  URLTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2020-03-26.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct URLTests {}

extension URLTests {
    @Test
    func safeStringKeepsTheLiteralItIsGiven() {
        #expect(URL(safeString: "https://apple.com/iphone?ref=1#top").absoluteString == "https://apple.com/iphone?ref=1#top")
        #expect(URL.invalidURL.absoluteString == "https://")
    }
}

extension URLTests {
    @Test
    func replacingPathExtension() throws {
        let url = URL(fileURLWithPath: "/SomePath/SomeTests.swift")
        let expected = "/SomePath/SomeTests.json"
        #expect(url.replacingPathExtension("json").path == expected)
    }

    @Test
    func uRLAppendingToFileName() throws {
        let url = URL(fileURLWithPath: "/SomePath/SomeTests.json")
        let expected = "/SomePath/SomeTests123.json"
        #expect(url.appendingToFileName("123").path == expected)
    }
}
