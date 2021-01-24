//
//  NetworkAPI.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSData
import Foundation.NSURLRequest

public protocol NetworkService {
    func send(with request: URLRequest, completion: @escaping (NetworkAPI.URLResult) -> Void)
}

// MARK: - Types

/// A type that can inspect and optionally adapt a `URLRequest` in some manner if necessary.
public protocol URLRequestAdapter {
    
    /// Inspects and adapts the specified `URLRequest` in some manner and returns the new request.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to adapt.
    func adapt(_ request: URLRequest) -> URLRequest
}

// MARK: - Namespace

public enum NetworkAPI {
    public typealias URLResult = Result<NetworkAPI.Response, NetworkAPI.Error>
    
    public struct Response {
        public let data: Data?
        public let headers: [String: String]
        public let statusCode: Int
        public let request: URLRequest

        public init(data: Data?, headers: [String: String], statusCode: Int, request: URLRequest) {
            self.data = data
            self.headers = headers
            self.statusCode = statusCode
            self.request = request
        }
    }
    
    public struct Error: Swift.Error {
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

extension NetworkAPI.Error: CustomStringConvertible, CustomDebugStringConvertible {
    
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
    
    public var debugDescription: String {
        """
        Error: \(internalError ?? ZamzamError.other(nil)),
        Request: {
            url: \(request.url?.absoluteString ?? ""),
            method: \(request.httpMethod ?? ""),
            body: \(request.httpBody?.string ?? ""),
            headers: \(request.allHTTPHeaderFields ?? [:])

        },
        Response: {
            status: \(statusCode ?? 0),
            body: \(data?.string ?? ""),
            headers: \(headers ?? [:])
        }
        """
    }
}
