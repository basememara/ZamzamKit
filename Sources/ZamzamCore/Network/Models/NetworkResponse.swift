//
//  NetworkResponse.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-06-15.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLRequest

/// The server response with included details from the network request.
public struct NetworkResponse: Sendable {
    /// The response body.
    public let data: Data
    /// The response's header fields, with names and values as strings.
    public let headers: [String: String]
    /// The HTTP status.
    public let statusCode: Int
    /// The request that was sent.
    public let request: URLRequest
    /// The response as `URLSession` returned it.
    public let response: URLResponse

    /// Creates a response from its parts.
    public init(
        data: Data,
        headers: [String: String],
        statusCode: Int,
        request: URLRequest,
        response: URLResponse
    ) {
        self.data = data
        self.headers = headers
        self.statusCode = statusCode
        self.request = request
        self.response = response
    }
}
