//
//  DateFormatterTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-04-17.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class DateFormatterTests: XCTestCase {}

extension DateFormatterTests {
    func testISO8601Formatter() throws {
        // Given
        struct Example: Decodable {
            let date: Date
        }

        let json = try XCTUnwrap(
            #"{"date": "2021-02-25T05:34:47+00:00"}"#.data(using: .utf8)
        )

        let decoder = JSONDecoder().apply {
            $0.dateDecodingStrategy = .formatted(DateFormatter.iso8601Formatter)
        }

        // When
        let object = try decoder.decode(Example.self, from: json)

        // Then
        XCTAssertEqual(object.date.timeIntervalSince1970, 1614231287)
    }
}

extension DateFormatterTests {
    func testZuluFormatter() throws {
        // Given
        struct Example: Decodable {
            let date: Date
        }

        let json = try XCTUnwrap(
            #"{"date": "2021-02-03T20:19:55.317Z"}"#.data(using: .utf8)
        )

        let decoder = JSONDecoder().apply {
            $0.dateDecodingStrategy = .formatted(DateFormatter.zuluFormatter)
        }

        // When
        let object = try decoder.decode(Example.self, from: json)

        // Then
        XCTAssertEqual(object.date.timeIntervalSince1970, 1612383595.317)
    }
}
