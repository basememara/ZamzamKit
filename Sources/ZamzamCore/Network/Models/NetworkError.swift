//
//  NetworkError.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-06-15.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSError
import Foundation.NSURLRequest

/// A failed network request: the request, with the response or the transport's error behind the failure.
public struct NetworkError: Error, Sendable {
    /// The original request that initiated the task.
    public let request: URLRequest

    /// The response body, when the server answered.
    public let data: Data?

    /// The response's header fields, when the server answered.
    public let headers: [String: String]?

    /// The HTTP status, when the server answered.
    public let statusCode: Int?

    /// The transport's error, when the request got no answer.
    public let internalError: Error?

    /// Creates an error for a request, with whatever is known of the response.
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
    /// The transport's error, the request's URL and method, and the status. Bodies and headers are left out.
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
    /// The description with the bodies and headers of the request and the response added. Debug builds only.
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
    /// Creates the error that matches a network error.
    ///
    /// An offline device, a timeout and a failed secure connection each have a case. Otherwise the status decides: 400 is
    /// `requestFailure`, 401 and 403 are `unauthorized`, and anything else is `serverFailure`.
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
