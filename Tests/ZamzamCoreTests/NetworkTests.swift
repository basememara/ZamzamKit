//
//  NetworkTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-01.
//

import XCTest
import ZamzamCore

final class NetworkTests: XCTestCase {
    private let jsonDecoder = JSONDecoder()
    
    private let networkRepository: NetworkRepositoryType = NetworkRepository(
        service: NetworkFoundationService()
    )
}

// MARK: - GET

extension NetworkTests {
    
    func testGET() {
        // Given
        let promise = expectation(description: #function)
        
        guard let url = URL(string: "https://httpbin.org/get") else {
            XCTFail("URL was not valid")
            return
        }
        
        let request = URLRequest(url: url, method: .get)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/get") else {
            XCTFail("URL was not valid")
            return
        }
        
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]
        
        let request = URLRequest(url: url, method: .get, parameters: parameters)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/get") else {
            XCTFail("URL was not valid")
            return
        }
        
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]
        
        let request = URLRequest(url: url, method: .get, headers: headers)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/post") else {
            XCTFail("URL was not valid")
            return
        }
        
        let request = URLRequest(url: url, method: .post)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/post") else {
            XCTFail("URL was not valid")
            return
        }
        
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]
        
        let request = URLRequest(url: url, method: .post, parameters: parameters)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/post") else {
            XCTFail("URL was not valid")
            return
        }
        
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]
        
        let request = URLRequest(url: url, method: .post, headers: headers)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/patch") else {
            XCTFail("URL was not valid")
            return
        }
        
        let request = URLRequest(url: url, method: .patch)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/patch") else {
            XCTFail("URL was not valid")
            return
        }
        
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]
        
        let request = URLRequest(url: url, method: .patch, parameters: parameters)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/patch") else {
            XCTFail("URL was not valid")
            return
        }
        
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]
        
        let request = URLRequest(url: url, method: .patch, headers: headers)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/put") else {
            XCTFail("URL was not valid")
            return
        }
        
        let request = URLRequest(url: url, method: .put)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/put") else {
            XCTFail("URL was not valid")
            return
        }
        
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]
        
        let request = URLRequest(url: url, method: .put, parameters: parameters)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/put") else {
            XCTFail("URL was not valid")
            return
        }
        
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]
        
        let request = URLRequest(url: url, method: .put, headers: headers)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/delete") else {
            XCTFail("URL was not valid")
            return
        }
        
        let request = URLRequest(url: url, method: .delete)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/delete") else {
            XCTFail("URL was not valid")
            return
        }
        
        let parameters: [String: Any] = [
            "abc": 123,
            "def": "test456",
            "xyz": true
        ]
        
        let request = URLRequest(url: url, method: .delete, parameters: parameters)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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
        
        guard let url = URL(string: "https://httpbin.org/delete") else {
            XCTFail("URL was not valid")
            return
        }
        
        let headers: [String: String] = [
            "Abc": "test123",
            "Def": "test456",
            "Xyz": "test789"
        ]
        
        let request = URLRequest(url: url, method: .delete, headers: headers)
        var response: NetworkAPI.Response?
        
        // When
        networkRepository.send(with: request) {
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

// MARK: - Multiple

extension NetworkTests {
    
    func testMultipleRequests() {
        // Given
        let promise = expectation(description: #function)
        
        guard let urlGet = URL(string: "https://httpbin.org/get"),
            let urlPost = URL(string: "https://httpbin.org/post"),
            let urlPatch = URL(string: "https://httpbin.org/patch"),
            let urlDelete = URL(string: "https://httpbin.org/delete") else {
                XCTFail("URL was not valid")
                return
        }
        
        let requests = [
            URLRequest(url: urlGet, method: .get),
            URLRequest(url: urlPost, method: .post),
            URLRequest(url: urlPatch, method: .patch),
            URLRequest(url: urlDelete, method: .delete)
        ]
        
        var response0: NetworkAPI.Response?
        var response1: NetworkAPI.Response?
        var response2: NetworkAPI.Response?
        var response3: NetworkAPI.Response?
        
        // When
        networkRepository.send(requests: requests[0], requests[1], requests[2], requests[3]) { results in
            defer { promise.fulfill() }
            
            guard case .success(let value0) = results[0] else {
                XCTFail("The network request failed: \(String(describing: results[0].error))")
                return
            }
            
            guard case .success(let value1) = results[1] else {
                XCTFail("The network request failed: \(String(describing: results[1].error))")
                return
            }
            
            guard case .success(let value2) = results[2] else {
                XCTFail("The network request failed: \(String(describing: results[2].error))")
                return
            }
            
            guard case .success(let value3) = results[3] else {
                XCTFail("The network request failed: \(String(describing: results[3].error))")
                return
            }
            
            response0 = value0
            response1 = value1
            response2 = value2
            response3 = value3
        }
        
        wait(for: [promise], timeout: 10)
        
        // Then
        XCTAssertEqual(requests[0].url?.absoluteString, "https://httpbin.org/get")
        XCTAssertNotNil(response0?.data)
        XCTAssertEqual(response0?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response0?.statusCode, 200)
        
        XCTAssertEqual(requests[1].url?.absoluteString, "https://httpbin.org/post")
        XCTAssertNotNil(response1?.data)
        XCTAssertEqual(response1?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response1?.statusCode, 200)
        
        XCTAssertEqual(requests[2].url?.absoluteString, "https://httpbin.org/patch")
        XCTAssertNotNil(response2?.data)
        XCTAssertEqual(response2?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response2?.statusCode, 200)
        
        XCTAssertEqual(requests[3].url?.absoluteString, "https://httpbin.org/delete")
        XCTAssertNotNil(response3?.data)
        XCTAssertEqual(response3?.headers["Content-Type"], "application/json")
        XCTAssertEqual(response3?.statusCode, 200)
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
