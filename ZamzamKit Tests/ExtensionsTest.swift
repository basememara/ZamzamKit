//
//  ExtensionsTest.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/31/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import XCTest
@testable import ZamzamKit

class ExtensionsTest: XCTestCase {
    
    func testEquatableWithin() {
        XCTAssert("def".within(["abc", "def", "ghi"]))
        XCTAssert(!"xyz".within(["abc", "def", "ghi"]))
    }
    
    func testDictionaryUnion() {
        let moreAttributes: [String: String] = ["Function": "authenticate"]
        var attributes: [String: String] = ["File": "Auth.swift"]

        // Immutable
        XCTAssertEqual(attributes + moreAttributes + nil, ["Function": "authenticate", "File": "Auth.swift"])
        XCTAssertEqual(attributes + moreAttributes, ["Function": "authenticate", "File": "Auth.swift"])
        XCTAssertEqual(attributes + nil, ["File": "Auth.swift"])
        
        // Mutable
        attributes += nil
        XCTAssertEqual(attributes, ["File": "Auth.swift"])
        
        attributes += moreAttributes
        XCTAssertEqual(attributes, ["File": "Auth.swift", "Function": "authenticate"])
    }
    
    func testCombineHash() {
        // https://codereview.stackexchange.com/questions/148763/extending-cgpoint-to-conform-to-hashable
        var hv = Set<Int>()
        var count = 0
        for i in -200..<200 {
            for j in -200..<200 {
                count += 1
                let p = CGPoint(x: CGFloat(i)/20, y: CGFloat(j)/20)
                hv.insert(p.hashValue)
            }
        }

        // Accurracy threshold since hashable not 100% unique
        XCTAssertTrue(abs(count - hv.count) <= 40)
    }
}

extension CGPoint: Hashable {
    public var hashValue: Int {
        return combineHashes([
            x.hashValue,
            y.hashValue
        ])
    }
}
