//
//  WebHelperTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class WebTests: XCTestCase {

}

extension WebTests {
    
    func testStrippedHTML() {
        let value = "<html><head><title>Test</title></head><body></body></html>"
        let expectedValue = "Test"
        
        XCTAssertEqual(value.htmlStripped, expectedValue)
    }
    
    func testStrippedHTML2() {
        let test = "<p>This is <em>web</em> content with a <a href=\"http://example.com\">link</a>.</p>"
        let expected = "This is web content with a link."
        XCTAssertEqual(test.htmlStripped, expected)
    }
}

extension WebTests {
    
    func testDecodeHTML() {
        let value = "<strong> 4 &lt; 5 &amp; 3 &gt; 2 .</strong> Price: 12 &#x20ac;.  &#64;"
        
        let newValue = value.htmlDecoded()
        let expectedValue = "<strong> 4 < 5 & 3 > 2 .</strong> Price: 12 €.  @"
        
        XCTAssertEqual(newValue, expectedValue)
    }
}
