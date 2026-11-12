//
//  NetworkService.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLRequest

/// A service that performs an HTTP request, such as `NetworkServiceFoundation` over `URLSession`.
public protocol NetworkService: Sendable {
    /// Sends the request and returns the response, or throws when it fails.
    @discardableResult
    func send(_ request: URLRequest) async throws -> NetworkResponse
}
