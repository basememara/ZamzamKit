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

extension URLTests {
    @Test
    func appendingQueryItem() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"

        let newValue = URL(safeString: value).appendingQueryItem("aBc", value: "555").absoluteString
        let expectedValue = "https://example.com?lmn=tuv&xyz=987&aBc=555"

        #expect(newValue == expectedValue)
    }

    @Test
    func removeQueryStringParameter() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"

        let newValue = URL(safeString: value).removeQueryItem("xyz").absoluteString
        let expectedValue = "https://example.com?abc=123&lmn=tuv"

        #expect(newValue == expectedValue)
    }

    @Test
    func appendingQueryItemForAdd() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"

        #expect(URL(safeString: value).appendingQueryItem("def", value: "456").absoluteString == "https://example.com?abc=123&lmn=tuv&xyz=987&def=456")

        #expect(URL(safeString: value).appendingQueryItem("xyz", value: "999").absoluteString == "https://example.com?abc=123&lmn=tuv&xyz=999")
    }

    @Test
    func appendingQueryItemForList() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"

        let newValue = URL(safeString: value).appendingQueryItems([
            "def": "456",
            "jkl": "777",
            "abc": "333",
            "lmn": nil
        ]).absoluteString

        #expect(newValue.contains("abc=333"))
        #expect(newValue.contains("def=456"))
        #expect(newValue.contains("jkl=777"))
        #expect(newValue.contains("xyz=987"))
        #expect(!(newValue.contains("lmn=")))
    }

    @Test
    func appendingQueryItemForNoInitialParameters() {
        // Subfolder
        #expect(URL(safeString: "https://example.com/abc/xyz")
                .appendingQueryItem("abc", value: "123")
                .absoluteString == "https://example.com/abc/xyz?abc=123")

        // Hash in URL
        #expect(URL(safeString: "https://example.com/abc/xyz#test")
                .appendingQueryItem("xyz", value: "987")
                .absoluteString == "https://example.com/abc/xyz?xyz=987#test")

        // Subfolder with trailing slash
        #expect(URL(safeString: "https://example.com/abc/xyz/")
                .appendingQueryItem("abc", value: "123")
                .absoluteString == "https://example.com/abc/xyz/?abc=123")

        // Hash in URL with trailing slash
        #expect(URL(safeString: "https://example.com/abc/xyz/#test")
                .appendingQueryItem("xyz", value: "987")
                .absoluteString == "https://example.com/abc/xyz/?xyz=987#test")
    }

    @Test
    func appendingQueryItemForDomain() {
        // Pure domain
        #expect(URL(safeString: "https://example.com")
                .appendingQueryItem("abc", value: "123")
                .absoluteString == "https://example.com?abc=123")

        // With trailing slash
        #expect(URL(safeString: "https://example.com/")
                .appendingQueryItem("xyz", value: "987")
                .absoluteString == "https://example.com/?xyz=987")
    }

    @Test
    func appendingQueryItemForStrongTypes() {
        #expect(URL(safeString: "https://example.com")
                .appendingQueryItem("abc", value: 1)
                .absoluteString == "https://example.com?abc=1")

        #expect(URL(safeString: "https://example.com/")
                .appendingQueryItem("xyz", value: true)
                .absoluteString == "https://example.com/?xyz=true")
    }
}

extension URLTests {
    @Test
    func getQueryItem() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"

        #expect(URL(safeString: value).queryItem("aBc") == "123")
        #expect(URL(safeString: value).queryItem("lmn") == "tuv")
        #expect(URL(safeString: value).queryItem("yyy") == nil)
    }
}
