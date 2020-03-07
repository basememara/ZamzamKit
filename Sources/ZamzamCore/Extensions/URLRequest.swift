//
//  URLRequest.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation

public extension URLRequest {
    
    /// Type representing HTTP methods.
    ///
    /// See https://tools.ietf.org/html/rfc7231#section-4.3
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
}

public extension URLRequest {
    
    /// Creates an instance with JSON specific configurations.
    ///
    /// - Parameters:
    ///   - url: The URL of the request.
    ///   - method: The HTTP request method.
    ///   - parameters: The data sent as the message body of a request.
    ///   - headers: A dictionary containing all of the HTTP header fields for a request.
    ///   - timeoutInterval: The timeout interval of the request. If `nil`, the defaults is 10 seconds.
    init(
        url: URL,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        timeoutInterval: TimeInterval = 10
    ) {
        // Not all HTTP methods support body
        let doesSupportBody = !method.within([.get, .delete])
        
        self.init(
            url: !doesSupportBody
                // Parameters become query string parameters for some methods
                ? url.appendingQueryItems(parameters ?? [:])
                : url
        )
        
        self.httpMethod = method.rawValue
        
        self.allHTTPHeaderFields = headers
        self.addValue("application/json", forHTTPHeaderField: "Accept")
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Parameters become serialized into body for all other HTTP methods
        if let parameters = parameters, !parameters.isEmpty, doesSupportBody {
            self.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        self.timeoutInterval = timeoutInterval
    }
}

public extension URLRequest {
    
    /// Creates an instance with JSON specific configurations.
    ///
    /// - Parameters:
    ///   - url: The URL of the request.
    ///   - method: The HTTP request method.
    ///   - data: The data sent as the message body of a request.
    ///   - headers: A dictionary containing all of the HTTP header fields for a request.
    ///   - timeoutInterval: The timeout interval of the request. If `nil`, the defaults is 10 seconds.
    init(
        url: URL,
        method: HTTPMethod,
        data: Data?,
        headers: [String: String]? = nil,
        timeoutInterval: TimeInterval = 10
    ) {
        self.init(url: url)
        
        self.httpMethod = method.rawValue
        
        self.allHTTPHeaderFields = headers
        self.addValue("application/json", forHTTPHeaderField: "Accept")
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let data = data, method != .get {
            self.httpBody = data
        }
        
        self.timeoutInterval = timeoutInterval
    }
}
