//
//  NetworkFoundationService.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation

public struct NetworkFoundationService: NetworkService {
    public init() {}
}

public extension NetworkFoundationService {
    
    func send(with request: URLRequest, completion: @escaping (Result<NetworkAPI.Response, NetworkAPI.Error>) -> Void) {
        URLSession.shared.dataTask(
            with: request,
            completionHandler: completion
        ).resume()
    }
}

// MARK: - Helpers

private extension URLSession {
    
    /// Creates a task that retrieves the contents of a URL based on the specified URL request object, and calls a handler upon completion.
    ///
    /// - Parameters:
    ///   - request: A URL request object that provides the URL, cache policy, request type, body data or body stream, and so on.
    ///   - completionHandler: The completion handler to call when the load request is complete. This handler is executed on the main queue.
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Result<NetworkAPI.Response, NetworkAPI.Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: request) { (data, response, error) in
            if let error = error {
                let networkError = NetworkAPI.Error(request: request, internalError: error)
                DispatchQueue.main.async { completionHandler(.failure(networkError)) }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let networkError = NetworkAPI.Error(request: request)
                DispatchQueue.main.async { completionHandler(.failure(networkError)) }
                return
            }
            
            let headers: [String: String] = Dictionary(
                uniqueKeysWithValues: httpResponse.allHeaderFields.map { ("\($0)", "\($1)") }
            )
            
            guard let data = data else {
                let networkError = NetworkAPI.Error(request: request, headers: headers, statusCode: httpResponse.statusCode)
                DispatchQueue.main.async { completionHandler(.failure(networkError)) }
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                let networkError = NetworkAPI.Error(request: request, data: data, headers: headers, statusCode: httpResponse.statusCode)
                DispatchQueue.main.async { completionHandler(.failure(networkError)) }
                return
            }
            
            DispatchQueue.main.async {
                let networkResponse = NetworkAPI.Response(data: data, headers: headers, statusCode: httpResponse.statusCode)
                completionHandler(.success(networkResponse))
            }
        }
    }
}
