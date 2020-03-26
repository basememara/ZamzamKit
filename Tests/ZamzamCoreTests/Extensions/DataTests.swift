//
//  DataTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class DataTests: XCTestCase {}
    
extension DataTests {
    
    func testString() {
        let dataFromString = "hello".data(using: .utf8)
        XCTAssertNotNil(dataFromString)
        XCTAssertNotNil(dataFromString?.string(encoding: .utf8))
        XCTAssertEqual(dataFromString?.string(encoding: .utf8), "hello")
    }
}

extension DataTests {
    
    func testHexString() {
        XCTAssertEqual(
            "hbjJBJjhbjhad f7s7dtf7 sugyo87T^IT*iyug".data(using: .utf8)?.hexString(),
            "68626a4a424a6a68626a68616420663773376474663720737567796f3837545e49542a69797567"
        )
    }
}

extension DataTests {
    
    func testBase64URLEncodedString() {
        XCTAssertEqual(
            "dsva-kjKH IU_H78yds8/7fyt78O TD+SY*O&*&T*A&(A*SF Y d8=q933827 z*&T*(ui sda dssd2&^%adjkh alkdjfl".data(using: .utf8)?.base64URLEncodedString(),
            "ZHN2YS1raktIIElVX0g3OHlkczgvN2Z5dDc4TyBURCtTWSpPJiomVCpBJihBKlNGIFkgZDg9cTkzMzgyNyB6KiZUKih1aSBzZGEgZHNzZDImXiVhZGpraCBhbGtkamZs"
        )
    }
}
