//
//  NetworkTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2020-03-01.
//

import XCTest
import ZamzamCore

final class NetworkTests: XCTestCase {
    private let jsonDecoder = JSONDecoder()
    
    private let networkProvider: NetworkProviderType = NetworkProvider(
        store: NetworkURLSessionStore()
    )
}

// MARK: - GET
    
extension NetworkTests {
    
    func testGET() {
        // Given
        let promise = expectation(description: #function)
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/get")!,
            method: .get
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/get")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
    }
}

extension NetworkTests {
    
    func testGETWithParameters() {
        // Given
        let promise = expectation(description: #function)
        
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/get")!,
            method: .get,
            parameters: parameters
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssert(request.url?.absoluteString.contains("https://httpbin.org/get?") == true)
        XCTAssert(request.url?.absoluteString.contains("abc=123") == true)
        XCTAssert(request.url?.absoluteString.contains("def=test456") == true)
        XCTAssert(request.url?.absoluteString.contains("xyz=true") == true)
        
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
        
        guard let data = response?.data else {
            XCTFail("No response data was found")
            return
        }
        
        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: data)
            
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
    
    func testGETWithHeaders() {
        // Given
        let promise = expectation(description: #function)
        
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/get")!,
            method: .get,
            headers: headers
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/get")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
        
        guard let data = response?.data else {
            XCTFail("No response data was found")
            return
        }
        
        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: data)
            
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
    
    func testPOST() {
        // Given
        let promise = expectation(description: #function)
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/post")!,
            method: .post
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/post")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
    }
}

extension NetworkTests {
    
    func testPOSTWithParameters() {
        // Given
        let promise = expectation(description: #function)
        
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/post")!,
            method: .post,
            parameters: parameters
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/post")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
        
        guard let data = response?.data else {
            XCTFail("No response data was found")
            return
        }
        
        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: data)
            
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
    
    func testPOSTWithHeaders() {
        // Given
        let promise = expectation(description: #function)
        
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/post")!,
            method: .post,
            headers: headers
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/post")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
        
        guard let data = response?.data else {
            XCTFail("No response data was found")
            return
        }
        
        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: data)
            
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
    
    func testPATCH() {
        // Given
        let promise = expectation(description: #function)
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/patch")!,
            method: .patch
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/patch")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
    }
}

extension NetworkTests {
    
    func testPATCHWithParameters() {
        // Given
        let promise = expectation(description: #function)
        
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/patch")!,
            method: .patch,
            parameters: parameters
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/patch")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
        
        guard let data = response?.data else {
            XCTFail("No response data was found")
            return
        }
        
        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: data)
            
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
    
    func testPATCHWithHeaders() {
        // Given
        let promise = expectation(description: #function)
        
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/patch")!,
            method: .patch,
            headers: headers
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/patch")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
        
        guard let data = response?.data else {
            XCTFail("No response data was found")
            return
        }
        
        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: data)
            
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
    
    func testPUT() {
        // Given
        let promise = expectation(description: #function)
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/put")!,
            method: .put
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/put")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
    }
}

extension NetworkTests {
    
    func testPUTWithParameters() {
        // Given
        let promise = expectation(description: #function)
        
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/put")!,
            method: .put,
            parameters: parameters
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/put")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
        
        guard let data = response?.data else {
            XCTFail("No response data was found")
            return
        }
        
        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: data)
            
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
    
    func testPUTWithHeaders() {
        // Given
        let promise = expectation(description: #function)
        
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/put")!,
            method: .put,
            headers: headers
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/put")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
        
        guard let data = response?.data else {
            XCTFail("No response data was found")
            return
        }
        
        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: data)
            
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
    
    func testDELETE() {
        // Given
        let promise = expectation(description: #function)
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/delete")!,
            method: .delete
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/delete")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
    }
}

extension NetworkTests {
    
    func testDELETEWithParameters() {
        // Given
        let promise = expectation(description: #function)
        
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/delete")!,
            method: .delete,
            parameters: parameters
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssert(request.url?.absoluteString.contains("https://httpbin.org/delete?") == true)
        XCTAssert(request.url?.absoluteString.contains("abc=123") == true)
        XCTAssert(request.url?.absoluteString.contains("def=test456") == true)
        XCTAssert(request.url?.absoluteString.contains("xyz=true") == true)
        
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
        
        guard let data = response?.data else {
            XCTFail("No response data was found")
            return
        }
        
        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: data)
            
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
    
    func testDELETEWithHeaders() {
        // Given
        let promise = expectation(description: #function)
        
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]
        
        let request = URLRequest(
            url: URL(string: "https://httpbin.org/delete")!,
            method: .delete,
            headers: headers
        )
        
        var response: NetworkAPI.Response?
        
        // When
        networkProvider.send(with: request) {
            defer { promise.fulfill() }
            
            guard case .success(let value) = $0 else {
                XCTFail("The network request failed: \(String(describing: $0.error))")
                return
            }
            
            response = value
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://httpbin.org/delete")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response?.statusCode, 200)
        
        guard let data = response?.data else {
            XCTFail("No response data was found")
            return
        }
        
        do {
            let model = try jsonDecoder.decode(ResponseModel.self, from: data)
            
            XCTAssertEqual(model.url, request.url?.absoluteString)
            
            headers.forEach {
                XCTAssertEqual(model.headers[$0.key], $0.value)
                
            }
        } catch {
            XCTFail("The resonse data could not be parse: \(error)")
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
