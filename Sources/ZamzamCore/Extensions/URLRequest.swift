//
//  URLRequest.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

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

    /// What a request sends: parameters to encode, or data to send as it is.
    enum Body {
        /// Values sent in the query string for GET and DELETE, and as a JSON body for every other method.
        case parameters([String: Any])
        /// Data sent as the body as it is. A GET request sends none.
        case data(Data)
    }

    /// The credentials written to the request's `Authorization` header.
    enum Authentication {
        /// A user name and password, sent as HTTP Basic.
        case basic(username: String, password: String)
        /// A token, sent as `Bearer` followed by the token.
        case bearer(String)
    }
}

public extension URLRequest {
    /// Creates a JSON request from a dictionary of parameters.
    ///
    /// GET and DELETE put the parameters in the query string, replacing an item of the same name whatever its case.
    /// Every other method sends them as a JSON body.
    ///
    /// - Parameters:
    ///   - parameters: The values to send. A body is JSON, so parameters JSON can't hold, such as a `Date` or a
    ///     custom type, leave the request without one.
    ///   - headers: Header fields set over the defaults, which are `Accept` and `Content-Type` of `application/json`.
    ///   - authentication: Credentials for the `Authorization` header, set over one in `headers`.
    ///   - timeoutInterval: The seconds the request waits for data before it fails.
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

        // Parameters become query string parameters for some methods, replacing an item of the same name
        if !doesSupportBody, let parameters, !parameters.isEmpty, var components = URLComponents(string: url.absoluteString) {
            let names = parameters.keys.map { $0.lowercased() }

            components.queryItems = (components.queryItems ?? [])
                .filter { !names.contains($0.name.lowercased()) }
                + parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }

            self.init(url: components.url ?? url)
        } else {
            self.init(url: url)
        }

        self.httpMethod = method.rawValue

        // Parameters become serialized into body for all other HTTP methods
        if let parameters, !parameters.isEmpty, doesSupportBody {
            self.httpBody = parameters.jsonData()
        }

        self.timeoutInterval = timeoutInterval
        self.merge(headers: headers, with: authentication)
    }
}

public extension URLRequest {
    /// Creates a JSON request with data as its body.
    ///
    /// The headers, authentication and timeout follow `init(url:method:parameters:headers:authentication:timeoutInterval:)`.
    ///
    /// - Parameter data: The body, sent as it is. A GET request sends none.
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

        if let data, method != .get {
            self.httpBody = data
        }

        self.timeoutInterval = timeoutInterval
        self.merge(headers: headers, with: authentication)
    }
}

public extension URLRequest {
    /// Creates a JSON request from a body that is either parameters or data.
    ///
    /// Each kind of body follows the initializer that takes it, and a `nil` body sends none.
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
