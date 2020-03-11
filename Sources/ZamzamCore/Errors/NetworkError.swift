//
//  NetworkError.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSData
import Foundation.NSURLRequest

public struct NetworkError: Error {
    
    /// The original request that initiated the task.
    public let request: URLRequest
    
    /// The data from the response.
    public let data: Data?
    
    /// The HTTP header values from the response.
    public let headers: [String: String]?
    
    /// The status code from the server.
    public let statusCode: Int?
    
    /// The internal error from the network request.
    public let internalError: Error?
}

extension NetworkError: CustomStringConvertible {
    
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
}
