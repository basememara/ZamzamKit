//
//  NetworkManager.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-02-27.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLRequest

/// A manager that creates and manages network requests.
///
/// Create requests using the extensions available for `URLRequest` that provides the URL, parameters, headers, and so on.
/// The network service provided in the intializer handles cache policy, trust management, and other underlying details.
///
///     let request = URLRequest(
///         url: URL(string: "https://httpbin.org/get")!,
///         method: .get,
///         parameters: [
///             "abc": 123,
///             "def": "test456",
///             "xyz": true
///         ],
///         headers: [
///             "Abc": "test123",
///             "Def": "test456",
///             "Xyz": "test789"
///         ]
///     )
///
///     let networkManager = NetworkManager(
///         service: NetworkServiceFoundation()
///     )
///
///     networkManager.send(request) { result in
///         switch result {
///         case let .success(response):
///             response.data
///             response.headers
///             response.statusCode
///         case let .failure(error):
///             error.statusCode
///         }
///     }
public struct NetworkManager {
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
    /// Creates a task that retrieves the contents of a URL based on the specified request object, and calls a handler upon completion.
    ///
    /// - Parameters:
    ///   - request: A network request object that provides the URL, parameters, headers, and so on.
    ///   - completion: The completion handler to call when the load request is complete.
    func send(
        _ request: URLRequest,
        completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void
    ) {
        let request = adapter?.adapt(request) ?? request
        service.send(request, completion: completion)
    }
}

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension NetworkManager {
    /// Creates a task that retrieves the contents of a URL based on the specified request object, and calls a handler upon completion.
    ///
    /// - Parameters:
    ///   - request: A network request object that provides the URL, parameters, headers, and so on.
    /// - Returns: A publisher that provides a single response from the request.
    func send(request: URLRequest) -> Future<NetworkResponse, NetworkError> {
        Future<NetworkResponse, NetworkError> {
            send(request, completion: $0)
        }
    }
}
#endif
