//
//  URLTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-26.
//

import XCTest
import ZamzamCore

final class URLTests: XCTestCase {}

extension URLTests {
    
    func testReplacingPathExtension() throws {
        let url = URL(fileURLWithPath: "/SomePath/SomeTests.swift")
        let expected = "/SomePath/SomeTests.json"
        XCTAssertEqual(url.replacingPathExtension("json").path, expected)
    }
    
    func testURLAppendingToFileName() throws {
        let url = URL(fileURLWithPath: "/SomePath/SomeTests.json")
        let expected = "/SomePath/SomeTests123.json"
        XCTAssertEqual(url.appendingToFileName("123").path, expected)
    }
}

extension URLTests {
    
    func testAppendingQueryItem() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"
        
        let newValue = URL(safeString: value).appendingQueryItem("aBc", value: "555").absoluteString
        let expectedValue = "https://example.com?lmn=tuv&xyz=987&aBc=555"
        
        XCTAssertEqual(newValue, expectedValue)
    }
    
    func testRemoveQueryStringParameter() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"
        
        let newValue = URL(safeString: value).removeQueryItem("xyz").absoluteString
        let expectedValue = "https://example.com?abc=123&lmn=tuv"
        
        XCTAssertEqual(newValue, expectedValue)
    }
    
    func testAppendingQueryItemForAdd() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"
        
        XCTAssertEqual(
            URL(safeString: value).appendingQueryItem("def", value: "456").absoluteString,
            "https://example.com?abc=123&lmn=tuv&xyz=987&def=456"
        )
        
        XCTAssertEqual(
            URL(safeString: value).appendingQueryItem("xyz", value: "999").absoluteString,
            "https://example.com?abc=123&lmn=tuv&xyz=999"
        )
    }
    
    func testAppendingQueryItemForList() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"
        
        let newValue = URL(safeString: value).appendingQueryItems([
            "def": "456",
            "jkl": "777",
            "abc": "333",
            "lmn": nil
        ]).absoluteString
        
        XCTAssertTrue(newValue.contains("abc=333"))
        XCTAssertTrue(newValue.contains("def=456"))
        XCTAssertTrue(newValue.contains("jkl=777"))
        XCTAssertTrue(newValue.contains("xyz=987"))
        XCTAssertFalse(newValue.contains("lmn="))
    }
    
    func testAppendingQueryItemForNoInitialParameters() {
        // Subfolder
        XCTAssertEqual(
            URL(safeString: "https://example.com/abc/xyz")
                .appendingQueryItem("abc", value: "123")
                .absoluteString,
            "https://example.com/abc/xyz?abc=123"
        )
        
        // Hash in URL
        XCTAssertEqual(
            URL(safeString: "https://example.com/abc/xyz#test")
                .appendingQueryItem("xyz", value: "987")
                .absoluteString,
            "https://example.com/abc/xyz?xyz=987#test"
        )
        
        // Subfolder with trailing slash
        XCTAssertEqual(
            URL(safeString: "https://example.com/abc/xyz/")
                .appendingQueryItem("abc", value: "123")
                .absoluteString,
            "https://example.com/abc/xyz/?abc=123"
        )
        
        // Hash in URL with trailing slash
        XCTAssertEqual(
            URL(safeString: "https://example.com/abc/xyz/#test")
                .appendingQueryItem("xyz", value: "987")
                .absoluteString,
            "https://example.com/abc/xyz/?xyz=987#test"
        )
    }
    
    func testAppendingQueryItemForDomain() {
        // Pure domain
        XCTAssertEqual(
            URL(safeString: "https://example.com")
                .appendingQueryItem("abc", value: "123")
                .absoluteString,
            "https://example.com?abc=123"
        )
        
        // With trailing slash
        XCTAssertEqual(
            URL(safeString: "https://example.com/")
                .appendingQueryItem("xyz", value: "987")
                .absoluteString,
            "https://example.com/?xyz=987"
        )
    }
    
    func testAppendingQueryItemForStrongTypes() {
        XCTAssertEqual(
            URL(safeString: "https://example.com")
                .appendingQueryItem("abc", value: 1)
                .absoluteString,
            "https://example.com?abc=1"
        )
        
        XCTAssertEqual(
            URL(safeString: "https://example.com/")
                .appendingQueryItem("xyz", value: true)
                .absoluteString,
            "https://example.com/?xyz=true"
        )
    }
}

extension URLTests {
    
    func testGetQueryItem() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"
        
        XCTAssertEqual(URL(safeString: value).queryItem("aBc"), "123")
        XCTAssertEqual(URL(safeString: value).queryItem("lmn"), "tuv")
        XCTAssertNil(URL(safeString: value).queryItem("yyy"))
    }
}
