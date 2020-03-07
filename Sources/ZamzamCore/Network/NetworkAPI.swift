//
//  NetworkAPI.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation

// Namespace
public enum NetworkAPI {}

public protocol NetworkStore {
    func send(with request: URLRequest, completion: @escaping (Result<NetworkAPI.Response, NetworkError>) -> Void)
}

/// The wrapper to handle HTTP requests.
public protocol NetworkProviderType {
    
    /// Creates a task that retrieves the contents of a URL based on the specified request object, and calls a handler upon completion.
    ///
    ///         let request = URLRequest(
    ///             url: URL(string: "https://httpbin.org/get")!,
    ///             method: .get,
    ///             parameters: [
    ///                 "abc": 123,
    ///                 "def": "test456",
    ///                 "xyz": true
    ///             ],
    ///             headers: [
    ///                 "Abc": "test123",
    ///                 "Def": "test456",
    ///                 "Xyz": "test789"
    ///             ]
    ///         )
    ///
    ///         let networkProvider = NetworkProvider(
    ///             store: NetworkURLSessionStore()
    ///         )
    ///
    ///         networkProvider.send(with: request) { result in
    ///             switch result {
    ///             case .success(let response):
    ///                 response.data
    ///                 response.headers
    ///                 response.statusCode
    ///             case .failure(let error):
    ///                 error.statusCode
    ///             }
    ///         }
    ///
    /// - Parameters:
    ///   - request: A network request object that provides the URL, parameters, headers, and so on.
    ///   - completion: The completion handler to call when the load request is complete.
    func send(with request: URLRequest, completion: @escaping (Result<NetworkAPI.Response, NetworkError>) -> Void)
}

// MARK: - Requests / Responses

public extension NetworkAPI {
    
    struct Response {
        public let data: Data?
        public let headers: [String: String]
        public let statusCode: Int
    }
}
