//
//  NetworkTests.swift
//  ZamzamCoreTests
//
//  Created by Basem Emara on 2020-03-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import XCTest
@testable import ZamzamCore

final class EncodingStrategyTests: XCTestCase {}

extension EncodingStrategyTests {
    func testSnakeCase() throws {
        // Given
        struct Example: SnakeCaseKeyEncodable {
            let abcDef: String
            let baseUrl: URL
            let onceUponATime: String
            let xyz: Int
        }

        let object = Example(
            abcDef: "hij",
            baseUrl: URL(safeString: "https://example.com"),
            onceUponATime: "the fox jumped over the hill",
            xyz: 5
        )

        // When
        let encoder = JSONEncoder.make(for: object)
        encoder.outputFormatting = [.sortedKeys]

        // Then
        XCTAssertEqual(
            String(data: try encoder.encode(object), encoding: .utf8),
            "{\"abc_def\":\"hij\",\"base_url\":\"https:\\/\\/example.com\",\"once_upon_a_time\":\"the fox jumped over the hill\",\"xyz\":5}"
        )
    }
}

extension EncodingStrategyTests {
    func testISO8601Date() throws {
        // Given
        struct Example: ISO8601DateEncodable {
            let date: Date
        }

        let object = Example(
            date: Date(timeIntervalSince1970: 1614231287.4747)
        )

        // When
        let encoder = JSONEncoder.make(for: object)

        // Then
        XCTAssertEqual(
            String(data: try encoder.encode(object), encoding: .utf8),
            "{\"date\":\"2021-02-25T05:34:47.4750Z\"}"
        )
    }
}

extension EncodingStrategyTests {
    func testZuluDate() throws {
        // Given
        struct Example: ZuluDateEncodable {
            let date: Date
        }

        let object = Example(
            date: Date(timeIntervalSince1970: 1612383595.317)
        )

        // When
        let encoder = JSONEncoder.make(for: object)

        // Then
        XCTAssertEqual(
            String(data: try encoder.encode(object), encoding: .utf8),
            "{\"date\":\"2021-02-03T20:19:55.317+0000\"}"
        )
    }
}

extension EncodingStrategyTests {
    func testSnakeCaseAndISO8601Date() throws {
        // Given
        struct Example: ISO8601DateEncodable {
            let abcDef: String
            let date: Date
        }

        let object = Example(
            abcDef: "hij",
            date: Date(timeIntervalSince1970: 1614231287.4747)
        )

        // When
        let encoder = JSONEncoder.make(for: object)
        encoder.outputFormatting = [.sortedKeys]

        // Then
        XCTAssertEqual(
            String(data: try encoder.encode(object), encoding: .utf8),
            "{\"abcDef\":\"hij\",\"date\":\"2021-02-25T05:34:47.4750Z\"}"
        )
    }
}
