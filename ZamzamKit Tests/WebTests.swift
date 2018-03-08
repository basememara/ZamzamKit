//
//  WebHelperTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import ZamzamKit

class WebTests: XCTestCase {

    func teststrippedHTML() {
        let value = "<html><head><title>Test</title></head><body></body></html>"
        let expectedValue = "Test"
        
        XCTAssertEqual(value.htmlStripped, expectedValue,
            "String should be \(expectedValue)")
    }
    
    func testDecodeHTML() {
        let value = "<strong> 4 &lt; 5 &amp; 3 &gt; 2 .</strong> Price: 12 &#x20ac;.  &#64;"
        
        let newValue = value.htmlDecoded
        let expectedValue = "<strong> 4 < 5 & 3 > 2 .</strong> Price: 12 €.  @"
        
        XCTAssertEqual(newValue, expectedValue,
            "String should be \(expectedValue)")
    }
    
    func testappendingQueryItem() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"
        
        let newValue = URL(string: value)!.appendingQueryItem("aBc", value: "555")
        let expectedValue = "https://example.com?lmn=tuv&xyz=987&aBc=555"
        
        XCTAssertEqual(newValue, expectedValue,
            "String should be \(expectedValue)")
    }
    
    func testRemoveQueryStringParameter() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"
        
        let newValue = URL(string: value)!.removeQueryItem("xyz")
        let expectedValue = "https://example.com?abc=123&lmn=tuv"
        
        XCTAssertEqual(newValue, expectedValue,
            "String should be \(expectedValue)")
    }
    
    func testappendingQueryItemForAdd() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"
        
        let newValue = URL(string: value)!.appendingQueryItem("def", value: "456")
        let expectedValue = "https://example.com?abc=123&lmn=tuv&xyz=987&def=456"
        
        XCTAssertEqual(newValue, expectedValue,
            "String should be \(expectedValue)")
    }
    
    func testappendingQueryItemForList() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"
        
        let newValue = URL(string: value)!.appendingQueryItems([
            "def": "456",
            "jkl": "777",
            "abc": "333",
            "lmn": nil
        ])
        
        let expectedValue = "https://example.com?xyz=987&abc=333&jkl=777&def=456"
        
        XCTAssertEqual(newValue, expectedValue,
            "String should be \(expectedValue)")
    }
    
    func testappendingQueryItemForNoInitialParameters() {
        // Subfolder
        XCTAssertEqual(
            URL(string: "https://example.com/abc/xyz")!
                .appendingQueryItem("abc", value: "123"),
            "https://example.com/abc/xyz?abc=123"
        )
        
        // Hash in URL
        XCTAssertEqual(
            URL(string: "https://example.com/abc/xyz#test")!
                .appendingQueryItem("xyz", value: "987"),
            "https://example.com/abc/xyz?xyz=987#test"
        )
        
        // Subfolder with trailing slash
        XCTAssertEqual(
            URL(string: "https://example.com/abc/xyz/")!
                .appendingQueryItem("abc", value: "123"),
            "https://example.com/abc/xyz/?abc=123"
        )
        
        // Hash in URL with trailing slash
        XCTAssertEqual(
            URL(string: "https://example.com/abc/xyz/#test")!
                .appendingQueryItem("xyz", value: "987"),
            "https://example.com/abc/xyz/?xyz=987#test"
        )
    }
    
    func testappendingQueryItemForDomain() {
        // Pure domain
        XCTAssertEqual(
            URL(string: "https://example.com")!
                .appendingQueryItem("abc", value: "123"),
            "https://example.com?abc=123"
        )
        
        // With trailing slash
        XCTAssertEqual(
            URL(string: "https://example.com/")!
                .appendingQueryItem("xyz", value: "987"),
            "https://example.com/?xyz=987"
        )
    }
    
    func testappendingQueryItemForStrongTypes() {
        XCTAssertEqual(
            URL(string: "https://example.com")!
                .appendingQueryItem("abc", value: 1),
            "https://example.com?abc=1"
        )
        
        XCTAssertEqual(
            URL(string: "https://example.com/")!
                .appendingQueryItem("xyz", value: true),
            "https://example.com/?xyz=true"
        )
    }
}
