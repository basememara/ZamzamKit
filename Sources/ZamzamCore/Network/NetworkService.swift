//
//  NetworkService.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLRequest

public protocol NetworkService {
    /// Creates a task that retrieves the contents of a URL based on the specified request object, and calls a handler upon completion.
    ///
    /// - Parameters:
    ///   - request: A network request object that provides the URL, parameters, headers, and so on.
    ///   - completion: The completion handler to call when the load request is complete.
    func send(_ request: URLRequest) async throws -> NetworkResponse
}
