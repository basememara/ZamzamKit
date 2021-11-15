//
//  URLRequest.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSJSONSerialization
import Foundation.NSData
import Foundation.NSURLRequest

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

    enum Body {
        case parameters([String: Any])
        case data(Data)
    }

    enum Authentication {
        case basic(username: String, password: String)
        case bearer(String)
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
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        authentication: Authentication? = nil,
        timeoutInterval: TimeInterval = 10
    ) {
        // Not all HTTP methods support body
        let doesSupportBody = ![.get, .delete].contains(method)

        self.init(
            url: !doesSupportBody
                // Parameters become query string parameters for some methods
                ? url.appendingQueryItems(parameters ?? [:])
                : url
        )

        self.httpMethod = method.rawValue

        // Parameters become serialized into body for all other HTTP methods
        if let parameters = parameters, !parameters.isEmpty, doesSupportBody {
            self.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        self.timeoutInterval = timeoutInterval
        self.merge(headers: headers, with: authentication)
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
        authentication: Authentication? = nil,
        timeoutInterval: TimeInterval = 10
    ) {
        self.init(url: url)

        self.httpMethod = method.rawValue

        if let data = data, method != .get {
            self.httpBody = data
        }

        self.timeoutInterval = timeoutInterval
        self.merge(headers: headers, with: authentication)
    }
}

public extension URLRequest {
    /// Creates an instance with JSON specific configurations.
    ///
    /// - Parameters:
    ///   - url: The URL of the request.
    ///   - method: The HTTP request method.
    ///   - body: The details sent as the message body of a request.
    ///   - headers: A dictionary containing all of the HTTP header fields for a request.
    ///   - timeoutInterval: The timeout interval of the request. If `nil`, the defaults is 10 seconds.
    init(
        url: URL,
        method: HTTPMethod,
        body: Body?,
        headers: [String: String]? = nil,
        authentication: Authentication? = nil,
        timeoutInterval: TimeInterval = 10
    ) {
        switch body {
        case let .parameters(values):
            self.init(
                url: url,
                method: method,
                parameters: values,
                headers: headers,
                authentication: authentication,
                timeoutInterval: timeoutInterval
            )
        case let .data(data):
            self.init(
                url: url,
                method: method,
                data: data,
                headers: headers,
                authentication: authentication,
                timeoutInterval: timeoutInterval
            )
        case nil:
            self.init(
                url: url,
                method: method,
                parameters: nil,
                headers: headers,
                authentication: authentication,
                timeoutInterval: timeoutInterval
            )
        }
    }
}

// MARK: - Helpers

private extension URLRequest {
    mutating func merge(headers: [String: String]?, with authentication: Authentication?) {
        allHTTPHeaderFields = (allHTTPHeaderFields ?? [:])
            .merging([
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]) { $1 }
            .merging(headers ?? [:]) { $1 }

        switch authentication {
        case let .basic(username, password):
            let encoded = "\(username):\(password)".base64Encoded()
            setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
        case let .bearer(token):
            setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        case nil:
            break
        }
    }
}
