//
//  NetworkResponse.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-06-15.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLRequest

/// The server response with included details from the network request.
public struct NetworkResponse {
    public let data: Data
    public let headers: [String: String]
    public let statusCode: Int
    public let request: URLRequest

    public init(
        data: Data,
        headers: [String: String],
        statusCode: Int,
        request: URLRequest
    ) {
        self.data = data
        self.headers = headers
        self.statusCode = statusCode
        self.request = request
    }
}
