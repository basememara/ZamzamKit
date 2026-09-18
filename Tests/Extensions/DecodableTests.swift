//
//  DecodableTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-05-13.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct DecodableTests {
    private let jsonDecoder = JSONDecoder()
}

extension DecodableTests {
    @Test
    func fromString() throws {
        // Given
        struct TestModel: Decodable {
            let string: String
            let integer: Int
        }

        let jsonString = """
        {
            "string": "Abc",
            "integer": 123,
        }
        """

        // When
        let model = try jsonDecoder.decode(TestModel.self, from: jsonString)

        // Then
        #expect(model.string == "Abc")
        #expect(model.integer == 123)
    }
}

extension DecodableTests {
    @Test
    func anyDecodable() throws {
        // Given
        let jsonString = """
        {
            "code": "post_does_not_exist",
            "message": "The post you are looking for does not exist.",
            "data": {
                "boolean": true,
                "integer": 1,
                "double": 3.14159265358979323846,
                "string": "string",
                "date": "2019-06-01T12:31:58+00:00",
                "array": [1, 2, 3],
                "nested": {
                    "a": "alpha",
                    "b": "bravo",
                    "c": "charlie"
                }
            }
        }
        """

        guard let data = jsonString.data(using: .utf8) else {
            Issue.record("Bad JSON format")
            return
        }

        // Type used for decoding the server payload
        struct ServerResponse: Decodable {
            let code: String
            let message: String
            let data: [String: AnyDecodable]?
        }

        let decoder = JSONDecoder().apply {
            $0.dateDecodingStrategy = .formatted(.init(iso8601Format: "yyyy-MM-dd'T'HH:mm:ssZ"))
        }

        // When
        let payload = try decoder.decode(ServerResponse.self, from: data)

        // Then
        #expect(try #require((payload.data?["boolean"])?.value as? Bool) == true)
        #expect(try #require((payload.data?["integer"])?.value as? Int) == 1)
        #expect(abs((try #require((payload.data?["double"])?.value as? Double)) - (3.14159265358979323846)) <= 0.001)
        #expect(try #require((payload.data?["string"])?.value as? String) == "string")
        #expect(try #require((payload.data?["date"])?.value as? Date) == Date(timeIntervalSince1970: 1559392318))
        #expect(try #require((payload.data?["array"])?.value as? [Int]) == [1, 2, 3])
        #expect(try #require((payload.data?["nested"])?.value as? [String: String]) == ["a": "alpha", "b": "bravo", "c": "charlie"])
    }
}
