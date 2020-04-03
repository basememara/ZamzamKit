//
//  NetworkAPI.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSData
import Foundation.NSURLRequest

// MARK: - Respository

/// The wrapper to handle HTTP requests.
public protocol NetworkRepositoryType {
    
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
    ///         let networkRepository = NetworkRepository(
    ///             service: NetworkURLSessionService()
    ///         )
    ///
    ///         networkRepository.send(with: request) { result in
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
    func send(with request: URLRequest, completion: @escaping (Result<NetworkAPI.Response, NetworkAPI.Error>) -> Void)
    
    /// Create tasks that retrieves the contents of a URL based on the specified request objects, and calls a handler upon completion with the result matching the index of the request.
    ///
    ///         let request1 = URLRequest(
    ///             url: URL(string: "https://httpbin.org/get")!,
    ///             method: .get
    ///         )
    ///
    ///         let request2 = URLRequest(
    ///             url: URL(string: "https://httpbin.org/post")!,
    ///             method: .post
    ///         )
    ///
    ///         let request3 = URLRequest(
    ///             url: URL(string: "https://httpbin.org/delete")!,
    ///             method: .delete
    ///         )
    ///
    ///         networkRepository.send(requests: request1, request2, request3) { result in
    ///             switch result.0 {
    ///             case .success(let response):
    ///                 response.data
    ///             case .failure(let error):
    ///                 error.statusCode
    ///             }
    ///
    ///             switch result.1 {
    ///             case .success(let response):
    ///                 response.data
    ///             case .failure(let error):
    ///                 error.statusCode
    ///             }
    ///
    ///             switch result.2 {
    ///             case .success(let response):
    ///                 response.data
    ///             case .failure(let error):
    ///                 error.statusCode
    ///             }
    ///         }
    ///
    /// - Parameters:
    ///   - request1: The first network request object that provides the URL, parameters, headers, and so on.
    ///   - request2: The second network request object that provides the URL, parameters, headers, and so on.
    ///   - completion: The completion handler to call when the load requests have all completed.
    func send(requests request1: URLRequest, _ request2: URLRequest, completion: @escaping ((NetworkAPI.URLResult, NetworkAPI.URLResult)) -> Void)
    
    /// Create tasks that retrieves the contents of a URL based on the specified request objects, and calls a handler upon completion with the result matching the index of the request.
    ///
    ///         let request1 = URLRequest(
    ///             url: URL(string: "https://httpbin.org/get")!,
    ///             method: .get
    ///         )
    ///
    ///         let request2 = URLRequest(
    ///             url: URL(string: "https://httpbin.org/post")!,
    ///             method: .post
    ///         )
    ///
    ///         let request3 = URLRequest(
    ///             url: URL(string: "https://httpbin.org/delete")!,
    ///             method: .delete
    ///         )
    ///
    ///         networkRepository.send(requests: request1, request2, request3) { result in
    ///             switch result.0 {
    ///             case .success(let response):
    ///                 response.data
    ///             case .failure(let error):
    ///                 error.statusCode
    ///             }
    ///
    ///             switch result.1 {
    ///             case .success(let response):
    ///                 response.data
    ///             case .failure(let error):
    ///                 error.statusCode
    ///             }
    ///
    ///             switch result.2 {
    ///             case .success(let response):
    ///                 response.data
    ///             case .failure(let error):
    ///                 error.statusCode
    ///             }
    ///         }
    ///
    /// - Parameters:
    ///   - request1: The first network request object that provides the URL, parameters, headers, and so on.
    ///   - request2: The second network request object that provides the URL, parameters, headers, and so on.
    ///   - request3: The third network request object that provides the URL, parameters, headers, and so on.
    ///   - completion: The completion handler to call when the load requests have all completed.
    func send(
        requests request1: URLRequest,
        _ request2: URLRequest,
        _ request3: URLRequest,
        completion: @escaping ((NetworkAPI.URLResult, NetworkAPI.URLResult, NetworkAPI.URLResult)) -> Void
    )
    
    /// Create tasks that retrieves the contents of a URL based on the specified request objects, and calls a handler upon completion with the result matching the index of the request.
    ///
    ///         let request1 = URLRequest(
    ///             url: URL(string: "https://httpbin.org/get")!,
    ///             method: .get
    ///         )
    ///
    ///         let request2 = URLRequest(
    ///             url: URL(string: "https://httpbin.org/post")!,
    ///             method: .post
    ///         )
    ///
    ///         let request3 = URLRequest(
    ///             url: URL(string: "https://httpbin.org/delete")!,
    ///             method: .delete
    ///         )
    ///
    ///         networkRepository.send(requests: request1, request2, request3) { result in
    ///             switch result.0 {
    ///             case .success(let response):
    ///                 response.data
    ///             case .failure(let error):
    ///                 error.statusCode
    ///             }
    ///
    ///             switch result.1 {
    ///             case .success(let response):
    ///                 response.data
    ///             case .failure(let error):
    ///                 error.statusCode
    ///             }
    ///
    ///             switch result.2 {
    ///             case .success(let response):
    ///                 response.data
    ///             case .failure(let error):
    ///                 error.statusCode
    ///             }
    ///         }
    ///
    /// - Parameters:
    ///   - request1: The first network request object that provides the URL, parameters, headers, and so on.
    ///   - request2: The second network request object that provides the URL, parameters, headers, and so on.
    ///   - request3: The third network request object that provides the URL, parameters, headers, and so on.
    ///   - request4: The fourth network request object that provides the URL, parameters, headers, and so on.
    ///   - completion: The completion handler to call when the load requests have all completed.
    func send(
        requests request1: URLRequest,
        _ request2: URLRequest,
        _ request3: URLRequest,
        _ request4: URLRequest,
        completion: @escaping ((NetworkAPI.URLResult, NetworkAPI.URLResult, NetworkAPI.URLResult, NetworkAPI.URLResult)) -> Void
    )
}

// MARK: - Service

public protocol NetworkService {
    func send(with request: URLRequest, completion: @escaping (Result<NetworkAPI.Response, NetworkAPI.Error>) -> Void)
}

// MARK: - Namespace

public enum NetworkAPI {
    public typealias URLResult = Result<NetworkAPI.Response, NetworkAPI.Error>
    
    public struct Response {
        public let data: Data?
        public let headers: [String: String]
        public let statusCode: Int
        
        public init(data: Data?, headers: [String: String], statusCode: Int) {
            self.data = data
            self.headers = headers
            self.statusCode = statusCode
        }
    }
    
    public struct Error: Swift.Error, CustomStringConvertible {
        /// The original request that initiated the task.
        public let request: URLRequest
        
        /// The data from the response.
        public let data: Data?
        
        /// The HTTP header values from the response.
        public let headers: [String: String]?
        
        /// The status code from the server.
        public let statusCode: Int?
        
        /// The internal error from the network request.
        public let internalError: Swift.Error?
        
        public var description: String {
            """
            Error: \(internalError ?? ZamzamError.other(nil)),
            Request: {
                url: \(request.url?.absoluteString ?? ""),
                method: \(request.httpMethod ?? "")
            },
            Response: {
                status: \(statusCode ?? 0)
            }
            """
        }
        
        public init(
            request: URLRequest,
            data: Data? = nil,
            headers: [String: String]? = nil,
            statusCode: Int? = nil,
            internalError: Swift.Error? = nil
        ) {
            self.request = request
            self.data = data
            self.headers = headers
            self.statusCode = statusCode
            self.internalError = internalError
        }
    }
}
