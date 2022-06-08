//
//  NetworkError.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-06-15.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLRequest
import Foundation.NSError

/// The server error with included details from the network request.
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

    public init(
        request: URLRequest,
        data: Data? = nil,
        headers: [String: String]? = nil,
        statusCode: Int? = nil,
        internalError: Error? = nil
    ) {
        self.request = request
        self.data = data
        self.headers = headers
        self.statusCode = statusCode
        self.internalError = internalError
    }
}

extension NetworkError: CustomStringConvertible {
    public var description: String {
        """
        \(internalError.map { "\($0)," } ?? "")
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

#if DEBUG
extension NetworkError: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        \(internalError.map { "\($0)," } ?? "")
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
#endif

// MARK: - Conversions

public extension ZamzamError {
    /// Convert from network error.
    init(from error: NetworkError) {
        switch error.internalError {
        case .some(URLError.notConnectedToInternet):
            self = .noInternet
        case .some(URLError.timedOut):
            self = .timeout
        case .some(URLError.secureConnectionFailed):
            self = .secureFailure(error)
        default:
            // Handle by status code
            switch error.statusCode {
            case 400:
                self = .requestFailure(error)
            case 401, 403:
                self = .unauthorized
            default:
                self = .serverFailure(error)
            }
        }
    }
}
