//
//  DataTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-05-11.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct DataTests {}

extension DataTests {
    @Test
    func string() {
        let dataFromString = "hello".data(using: .utf8)
        #expect(dataFromString != nil)
        #expect(dataFromString?.string(encoding: .utf8) == "hello")
    }
}

extension DataTests {
    @Test
    func hexString() {
        #expect("hbjJBJjhbjhad f7s7dtf7 sugyo87T^IT*iyug".data(using: .utf8)?.hexString() == "68626a4a424a6a68626a68616420663773376474663720737567796f3837545e49542a69797567")
    }
}

extension DataTests {
    @Test
    func base64URLEncodedString() {
        #expect("dsva-kjKH IU_H78yds8/7fyt78O TD+SY*O&*&T*A&(A*SF Y d8=q933827 z*&T*(ui sda dssd2&^%adjkh alkdjfl"
                .data(using: .utf8)?
                .base64URLEncodedString() == "ZHN2YS1raktIIElVX0g3OHlkczgvN2Z5dDc4TyBURCtTWSpPJiomVCpBJihBKlNGIFkgZDg9cTkzMzgyNyB6KiZUKih1aSBzZGEgZHNzZDImXiVhZGpraCBhbGtkamZs")
    }
}

extension DataTests {
    @Test
    func codable() throws {
        // Given
        struct TestModel: Codable, Equatable {
            let string: String
            let integer: Int
        }

        let expectedModel = TestModel(string: "abc", integer: 99)

        // When
        let data = try expectedModel.encode()
        let model: TestModel = try data.decode()

        // Then
        #expect(model == expectedModel)
    }
}
