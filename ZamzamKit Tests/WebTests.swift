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
    
    func testAddOrUpdateQueryStringParameter() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"
        
        let newValue = URLComponents(string: value)!.addOrUpdateQueryStringParameter("aBc", value: "555")
        let expectedValue = "https://example.com?aBc=555&lmn=tuv&xyz=987"
        
        XCTAssertEqual(newValue, expectedValue,
            "String should be \(expectedValue)")
    }
    
    func testRemoveQueryStringParameter() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"
        
        let newValue = URLComponents(string: value)!.removeQueryStringParameter("xyz")
        let expectedValue = "https://example.com?abc=123&lmn=tuv"
        
        XCTAssertEqual(newValue, expectedValue,
            "String should be \(expectedValue)")
    }
    
    func testAddOrUpdateQueryStringParameterForAdd() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"
        
        let newValue = URLComponents(string: value)!.addOrUpdateQueryStringParameter("def", value: "456")
        let expectedValue = "https://example.com?abc=123&lmn=tuv&xyz=987&def=456"
        
        XCTAssertEqual(newValue, expectedValue,
            "String should be \(expectedValue)")
    }
    
    func testAddOrUpdateQueryStringParameterForList() {
        let value = "https://example.com?abc=123&lmn=tuv&xyz=987"
        
        let newValue = URLComponents(string: value)!.addOrUpdateQueryStringParameter([
            "def": "456",
            "jkl": "777",
            "abc": "333",
            "lmn": nil
        ])
        
        let expectedValue = "https://example.com?abc=333&xyz=987&jkl=777&def=456"
        
        XCTAssertEqual(newValue, expectedValue,
            "String should be \(expectedValue)")
    }
}
