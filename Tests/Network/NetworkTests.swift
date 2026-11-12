//
//  NetworkTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

struct NetworkTests {
    private let jsonDecoder = JSONDecoder()

    private let networkManager = NetworkManager(
        service: NetworkServiceFoundation(configuration: .echo)
    )
}

// MARK: - GET

extension NetworkTests {
    @Test
    func gET() async throws {
        // Given
        let request = URLRequest(
            url: URL(safeString: "https://echo.test/get"),
            method: .get
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString == "https://echo.test/get")
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)
    }
}

extension NetworkTests {
    @Test
    func gETWithParameters() async throws {
        // Given
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]

        let request = URLRequest(
            url: URL(safeString: "https://echo.test/get"),
            method: .get,
            parameters: parameters
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString.contains("https://echo.test/get?") == true)
        #expect(request.url?.absoluteString.contains("abc=123") == true)
        #expect(request.url?.absoluteString.contains("def=test456") == true)
        #expect(request.url?.absoluteString.contains("xyz=true") == true)

        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            #expect(model.url == request.url?.absoluteString)

            parameters.forEach {
                #expect(model.args[$0.key] == "\($0.value)")
            }
        } catch {
            Issue.record("The resonse data could not be parse: \(error)")
        }
    }
}

extension NetworkTests {
    @Test
    func gETWithHeaders() async throws {
        // Given
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]

        let request = URLRequest(
            url: URL(safeString: "https://echo.test/get"),
            method: .get,
            headers: headers
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString == "https://echo.test/get")
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            #expect(model.url == request.url?.absoluteString)

            headers.forEach {
                #expect(model.headers[$0.key] == $0.value)
            }
        } catch {
            Issue.record("The resonse data could not be parse: \(error)")
        }
    }
}

// MARK: - POST

extension NetworkTests {
    @Test
    func pOST() async throws {
        // Given
        let request = URLRequest(
            url: URL(safeString: "https://echo.test/post"),
            method: .post
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString == "https://echo.test/post")
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)
    }
}

extension NetworkTests {
    @Test
    func pOSTWithParameters() async throws {
        // Given
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]

        let request = URLRequest(
            url: URL(safeString: "https://echo.test/post"),
            method: .post,
            parameters: parameters
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString == "https://echo.test/post")
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            #expect(model.url == request.url?.absoluteString)

            #expect(model.json?["abc"]?.value as? Int == 123)
            #expect(model.json?["def"]?.value as? String == "test456")
            #expect(model.json?["xyz"]?.value as? Bool == true)
        } catch {
            Issue.record("The resonse data could not be parse: \(error)")
        }
    }
}

extension NetworkTests {
    @Test
    func pOSTWithHeaders() async throws {
        // Given
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]

        let request = URLRequest(
            url: URL(safeString: "https://echo.test/post"),
            method: .post,
            headers: headers
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString == "https://echo.test/post")
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            #expect(model.url == request.url?.absoluteString)

            headers.forEach {
                #expect(model.headers[$0.key] == $0.value)
            }
        } catch {
            Issue.record("The resonse data could not be parse: \(error)")
        }
    }
}

// MARK: - PATCH

extension NetworkTests {
    @Test
    func pATCH() async throws {
        // Given
        let request = URLRequest(
            url: URL(safeString: "https://echo.test/patch"),
            method: .patch
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString == "https://echo.test/patch")
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)
    }
}

extension NetworkTests {
    @Test
    func pATCHWithParameters() async throws {
        // Given
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]

        let request = URLRequest(
            url: URL(safeString: "https://echo.test/patch"),
            method: .patch,
            parameters: parameters
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString == "https://echo.test/patch")
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            #expect(model.url == request.url?.absoluteString)

            #expect(model.json?["abc"]?.value as? Int == 123)
            #expect(model.json?["def"]?.value as? String == "test456")
            #expect(model.json?["xyz"]?.value as? Bool == true)
        } catch {
            Issue.record("The resonse data could not be parse: \(error)")
        }
    }
}

extension NetworkTests {
    @Test
    func pATCHWithHeaders() async throws {
        // Given
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]

        let request = URLRequest(
            url: URL(safeString: "https://echo.test/patch"),
            method: .patch,
            headers: headers
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString == "https://echo.test/patch")
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            #expect(model.url == request.url?.absoluteString)

            headers.forEach {
                #expect(model.headers[$0.key] == $0.value)
            }
        } catch {
            Issue.record("The resonse data could not be parse: \(error)")
        }
    }
}

// MARK: - PUT

extension NetworkTests {
    @Test
    func pUT() async throws {
        // Given
        let request = URLRequest(
            url: URL(safeString: "https://echo.test/put"),
            method: .put
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString == "https://echo.test/put")
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)
    }
}

extension NetworkTests {
    @Test
    func pUTWithParameters() async throws {
        // Given
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]

        let request = URLRequest(
            url: URL(safeString: "https://echo.test/put"),
            method: .put,
            parameters: parameters
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString == "https://echo.test/put")
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            #expect(model.url == request.url?.absoluteString)

            #expect(model.json?["abc"]?.value as? Int == 123)
            #expect(model.json?["def"]?.value as? String == "test456")
            #expect(model.json?["xyz"]?.value as? Bool == true)
        } catch {
            Issue.record("The resonse data could not be parse: \(error)")
        }
    }
}

extension NetworkTests {
    @Test
    func pUTWithHeaders() async throws {
        // Given
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]

        let request = URLRequest(
            url: URL(safeString: "https://echo.test/put"),
            method: .put,
            headers: headers
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString == "https://echo.test/put")
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            #expect(model.url == request.url?.absoluteString)

            headers.forEach {
                #expect(model.headers[$0.key] == $0.value)
            }
        } catch {
            Issue.record("The resonse data could not be parse: \(error)")
        }
    }
}

// MARK: - DELETE

extension NetworkTests {
    @Test
    func dELETE() async throws {
        // Given
        let request = URLRequest(
            url: URL(safeString: "https://echo.test/delete"),
            method: .delete
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString == "https://echo.test/delete")
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)
    }
}

extension NetworkTests {
    @Test
    func dELETEWithParameters() async throws {
        // Given
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]

        let request = URLRequest(
            url: URL(safeString: "https://echo.test/delete"),
            method: .delete,
            parameters: parameters
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString.contains("https://echo.test/delete?") == true)
        #expect(request.url?.absoluteString.contains("abc=123") == true)
        #expect(request.url?.absoluteString.contains("def=test456") == true)
        #expect(request.url?.absoluteString.contains("xyz=true") == true)

        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            #expect(model.url == request.url?.absoluteString)

            parameters.forEach {
                #expect(model.args[$0.key] == "\($0.value)")
            }
        } catch {
            Issue.record("The resonse data could not be parse: \(error)")
        }
    }
}

extension NetworkTests {
    @Test
    func dELETEWithHeaders() async throws {
        // Given
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]

        let request = URLRequest(
            url: URL(safeString: "https://echo.test/delete"),
            method: .delete,
            headers: headers
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(request.url?.absoluteString == "https://echo.test/delete")
        #expect(response.headers["Content-Type"] == "application/json")
        #expect(response.statusCode == 200)

        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: response.data)

            #expect(model.url == request.url?.absoluteString)

            headers.forEach {
                #expect(model.headers[$0.key] == $0.value)
            }
        } catch {
            Issue.record("The resonse data could not be parse: \(error)")
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

    @Test
    func withURLRequestAdapter() async throws {
        // Given
        let networkManager = NetworkManager(
            service: NetworkServiceFoundation(configuration: .echo),
            adapter: TestURLRequestAdapter()
        )

        let request = URLRequest(
            url: URL(safeString: "https://echo.test/get"),
            method: .get
        )

        // When
        let response = try await networkManager.send(request)

        // Then
        #expect(response.statusCode == 200)
        #expect(request.value(forHTTPHeaderField: "X-Test-1") == nil)
        #expect(request.value(forHTTPHeaderField: "X-Test-2") == nil)
        #expect(response.request.value(forHTTPHeaderField: "X-Test-1") == "1")
        #expect(response.request.value(forHTTPHeaderField: "X-Test-2") == "2")

        let sent = try jsonDecoder.decode(ResponseModel.self, from: response.data)
        #expect(sent.headers["X-Test-1"] == "1")
        #expect(sent.headers["X-Test-2"] == "2")
    }
}

// MARK: - Decoded

extension NetworkTests {
    @Test
    func decoded() async throws {
        // Given
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]

        let request = URLRequest(
            url: URL(safeString: "https://echo.test/get"),
            method: .get,
            parameters: parameters
        )

        // When
        let model: ResponseModel = try await networkManager.send(request)

        // Then
        #expect(model.url == request.url?.absoluteString)
        parameters.forEach { #expect(model.args[$0.key] == "\($0.value)") }
    }
}

// MARK: - Errors

extension NetworkTests {
    @Test
    func aStatusOutsideTheSuccessRangeThrowsWithTheResponse() async throws {
        // Given
        let request = URLRequest(
            url: URL(safeString: "https://echo.test/status/404"),
            method: .get
        )

        // When
        let error = try await #require(throws: NetworkError.self) {
            try await networkManager.send(request)
        }

        // Then
        #expect(error.statusCode == 404)
        #expect(error.headers?["Content-Type"] == "application/json")
        #expect(error.request.url == request.url)
        #expect(error.internalError == nil)

        let model = try jsonDecoder.decode(ResponseModel.self, from: try #require(error.data))
        #expect(model.url == request.url?.absoluteString)
    }

    @Test
    func aTransportFailureThrowsWithTheUnderlyingError() async throws {
        // Given
        let request = URLRequest(
            url: URL(safeString: "https://offline.test/get"),
            method: .get
        )

        // When
        let error = try await #require(throws: NetworkError.self) {
            try await networkManager.send(request)
        }

        // Then
        #expect((error.internalError as? URLError)?.code == .notConnectedToInternet)
        #expect(error.statusCode == nil)
        #expect(error.data == nil)

        guard case .noInternet = ZamzamError(from: error) else {
            Issue.record("A lost connection should convert to `noInternet`.")
            return
        }
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
