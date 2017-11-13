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
    
    func testWith() {
        let model = SomeModel().with {
            $0.propertyA = "abc"
            $0.propertyB = 5
            $0.propertyC = true
        }
        
        XCTAssertEqual(model.propertyA, "abc")
        XCTAssertEqual(model.propertyB, 5)
        XCTAssertEqual(model.propertyC, true)
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

class SomeModel {
    var propertyA: String?
    var propertyB: Int?
    var propertyC: Bool?
}

extension SomeModel: With {}
