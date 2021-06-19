//
//  NetworkTests.swift
//  ZamzamCoreTests
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class NetworkTests: XCTestCase {
    private let jsonDecoder = JSONDecoder()

    private let networkManager = NetworkManager(
        service: NetworkServiceFoundation()
    )
}

// MARK: - GET

extension NetworkTests {
    func testGET() async throws {
        // Given
        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/get"),
            method: .get
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/get")
        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)
    }
}

extension NetworkTests {
    func testGETWithParameters() async throws {
        // Given
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]

        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/get"),
            method: .get,
            parameters: parameters
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssert(request.url?.absoluteString.contains("https://httpbin.org/get?") == true)
        XCTAssert(request.url?.absoluteString.contains("abc=123") == true)
        XCTAssert(request.url?.absoluteString.contains("def=test456") == true)
        XCTAssert(request.url?.absoluteString.contains("xyz=true") == true)

        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            XCTAssertEqual(model.url, request.url?.absoluteString)

            parameters.forEach {
                XCTAssertEqual(model.args[$0.key], "\($0.value)")
            }
        } catch {
            XCTFail("The resonse data could not be parse: \(error)")
        }
    }
}

extension NetworkTests {
    func testGETWithHeaders() async throws {
        // Given
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]

        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/get"),
            method: .get,
            headers: headers
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/get")
        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            XCTAssertEqual(model.url, request.url?.absoluteString)

            headers.forEach {
                XCTAssertEqual(model.headers[$0.key], $0.value)
            }
        } catch {
            XCTFail("The resonse data could not be parse: \(error)")
        }
    }
}

// MARK: - POST

extension NetworkTests {
    func testPOST() async throws {
        // Given
        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/post"),
            method: .post
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/post")
        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)
    }
}

extension NetworkTests {
    func testPOSTWithParameters() async throws {
        // Given
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]

        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/post"),
            method: .post,
            parameters: parameters
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/post")
        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            XCTAssertEqual(model.url, request.url?.absoluteString)

            XCTAssertEqual(model.json?["abc"]?.value as? Int, 123)
            XCTAssertEqual(model.json?["def"]?.value as? String, "test456")
            XCTAssertEqual(model.json?["xyz"]?.value as? Bool, true)
        } catch {
            XCTFail("The resonse data could not be parse: \(error)")
        }
    }
}

extension NetworkTests {
    func testPOSTWithHeaders() async throws {
        // Given
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]

        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/post"),
            method: .post,
            headers: headers
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/post")
        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            XCTAssertEqual(model.url, request.url?.absoluteString)

            headers.forEach {
                XCTAssertEqual(model.headers[$0.key], $0.value)
            }
        } catch {
            XCTFail("The resonse data could not be parse: \(error)")
        }
    }
}

// MARK: - PATCH

extension NetworkTests {
    func testPATCH() async throws {
        // Given
        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/patch"),
            method: .patch
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/patch")
        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)
    }
}

extension NetworkTests {
    func testPATCHWithParameters() async throws {
        // Given
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]

        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/patch"),
            method: .patch,
            parameters: parameters
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/patch")
        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            XCTAssertEqual(model.url, request.url?.absoluteString)

            XCTAssertEqual(model.json?["abc"]?.value as? Int, 123)
            XCTAssertEqual(model.json?["def"]?.value as? String, "test456")
            XCTAssertEqual(model.json?["xyz"]?.value as? Bool, true)
        } catch {
            XCTFail("The resonse data could not be parse: \(error)")
        }
    }
}

extension NetworkTests {
    func testPATCHWithHeaders() async throws {
        // Given
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]

        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/patch"),
            method: .patch,
            headers: headers
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/patch")
        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            XCTAssertEqual(model.url, request.url?.absoluteString)

            headers.forEach {
                XCTAssertEqual(model.headers[$0.key], $0.value)
            }
        } catch {
            XCTFail("The resonse data could not be parse: \(error)")
        }
    }
}

// MARK: - PUT

extension NetworkTests {
    func testPUT() async throws {
        // Given
        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/put"),
            method: .put
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/put")
        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)
    }
}

extension NetworkTests {
    func testPUTWithParameters() async throws {
        // Given
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]

        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/put"),
            method: .put,
            parameters: parameters
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/put")
        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            XCTAssertEqual(model.url, request.url?.absoluteString)

            XCTAssertEqual(model.json?["abc"]?.value as? Int, 123)
            XCTAssertEqual(model.json?["def"]?.value as? String, "test456")
            XCTAssertEqual(model.json?["xyz"]?.value as? Bool, true)
        } catch {
            XCTFail("The resonse data could not be parse: \(error)")
        }
    }
}

extension NetworkTests {
    func testPUTWithHeaders() async throws {
        // Given
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]

        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/put"),
            method: .put,
            headers: headers
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/put")
        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            XCTAssertEqual(model.url, request.url?.absoluteString)

            headers.forEach {
                XCTAssertEqual(model.headers[$0.key], $0.value)
            }
        } catch {
            XCTFail("The resonse data could not be parse: \(error)")
        }
    }
}

// MARK: - DELETE

extension NetworkTests {
    func testDELETE() async throws {
        // Given
        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/delete"),
            method: .delete
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/delete")
        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)
    }
}

extension NetworkTests {
    func testDELETEWithParameters() async throws {
        // Given
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]

        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/delete"),
            method: .delete,
            parameters: parameters
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssert(request.url?.absoluteString.contains("https://httpbin.org/delete?") == true)
        XCTAssert(request.url?.absoluteString.contains("abc=123") == true)
        XCTAssert(request.url?.absoluteString.contains("def=test456") == true)
        XCTAssert(request.url?.absoluteString.contains("xyz=true") == true)

        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            XCTAssertEqual(model.url, request.url?.absoluteString)

            parameters.forEach {
                XCTAssertEqual(model.args[$0.key], "\($0.value)")
            }
        } catch {
            XCTFail("The resonse data could not be parse: \(error)")
        }
    }
}

extension NetworkTests {
    func testDELETEWithHeaders() async throws {
        // Given
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]

        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/delete"),
            method: .delete,
            headers: headers
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/delete")
        XCTAssertEqual(response.headers["Content-Type"], "application/json")
        XCTAssertEqual(response.statusCode, 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            XCTAssertEqual(model.url, request.url?.absoluteString)

            headers.forEach {
                XCTAssertEqual(model.headers[$0.key], $0.value)
            }
        } catch {
            XCTFail("The resonse data could not be parse: \(error)")
        }
    }
}

// MARK: - Adapter

extension NetworkTests {
    struct TestURLRequestAdapter: URLRequestAdapter {
        func adapt(_ request: URLRequest) -> URLRequest {
            var request = request
            request.setValue("1", forHTTPHeaderField: "X-Test-1")
            request.setValue("2", forHTTPHeaderField: "X-Test-2")
            return request
        }
    }

    func testWithURLRequestAdapter() async throws {
        // Given
        let networkManager = NetworkManager(
            service: NetworkServiceFoundation(),
            adapter: TestURLRequestAdapter()
        )

        let request = URLRequest(
            url: URL(safeString: "https://httpbin.org/get"),
            method: .get
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertNil(request.value(forHTTPHeaderField: "X-Test-1"))
        XCTAssertNil(request.value(forHTTPHeaderField: "X-Test-2"))
        XCTAssertEqual(response.request.value(forHTTPHeaderField: "X-Test-1"), "1")
        XCTAssertEqual(response.request.value(forHTTPHeaderField: "X-Test-2"), "2")
    }
}

// MARK: - Helpers

private extension NetworkTests {
    struct ResponseModel: Decodable {
        let url: String
        let args: [String: String]
        let headers: [String: String]
        let json: [String: AnyDecodable]?
    }
}

// swiftlint:disable:this file_length
