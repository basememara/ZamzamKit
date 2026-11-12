//
//  NetworkManager.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-02-27.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLRequest

/// Sends HTTP requests through a network service, after an optional adapter has changed them.
///
///     let request = URLRequest(
///         url: URL(safeString: "https://httpbin.org/get"),
///         method: .get,
///         parameters: ["abc": 123, "def": "test456"],
///         headers: ["Abc": "test123"]
///     )
///
///     let networkManager = NetworkManager(service: NetworkServiceFoundation())
///
///     do {
///         let response = try await networkManager.send(request)
///         print(response.statusCode)
///     } catch let error as NetworkError {
///         print(error.statusCode ?? 0)
///     } catch {
///         print(error)
///     }
public struct NetworkManager: Sendable {
    private let service: NetworkService
    private let adapter: URLRequestAdapter?

    /// Creates a network wrapper to handle HTTP requests.
    ///
    /// - Parameters:
    ///   - service: A service that performs the underlying HTTP request with a session.
    ///   - adapter: Inspects and adapts the specified `URLRequest` in some manner and returns the new request.
    public init(service: NetworkService, adapter: URLRequestAdapter? = nil) {
        self.service = service
        self.adapter = adapter
    }
}

public extension NetworkManager {
    /// Sends the request and returns the response.
    ///
    /// - Throws: The service's error. `NetworkServiceFoundation` throws a `NetworkError` when the connection fails or the
    ///   status is outside 200 to 299.
    @discardableResult
    func send(_ request: URLRequest) async throws -> NetworkResponse {
        let request = adapter?.adapt(request) ?? request
        return try await service.send(request)
    }

    /// Sends the request that `request` makes and returns the response.
    @discardableResult
    func send(_ request: URLRequestConvertible) async throws -> NetworkResponse {
        try await send(request.asURLRequest())
    }
}

public extension NetworkManager {
    /// Sends the request and returns the response body decoded from JSON.
    ///
    /// - Throws: The service's error, or the decoder's when the body isn't the JSON expected.
    func send<T>(_ request: URLRequest, using decoder: JSONDecoder = JSONDecoder()) async throws -> T where T: Decodable {
        let response = try await send(request)
        return try response.data.decode(decoder: decoder)
    }

    /// Sends the request that `request` makes and returns the response body decoded from JSON.
    func send<T>(_ request: URLRequestConvertible, using decoder: JSONDecoder = JSONDecoder()) async throws -> T where T: Decodable {
        try await send(request.asURLRequest(), using: decoder)
    }
}
