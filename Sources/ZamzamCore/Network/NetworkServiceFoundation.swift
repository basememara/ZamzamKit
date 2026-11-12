//
//  NetworkServiceFoundationAsync.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-06-17.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLSession

/// A network service over `URLSession`.
public struct NetworkServiceFoundation: NetworkService, Sendable {
    private let session: URLSession
    private let delegate: URLSessionTaskDelegate?

    /// Creates a service on a session of your own.
    ///
    /// - Parameter delegate: A delegate for each request's task, such as a `ServerTrustDelegate`.
    public init(session: URLSession, delegate: URLSessionTaskDelegate? = nil) {
        self.session = session
        self.delegate = delegate
    }

    /// Creates a service on a new session, with server trust evaluation for the hosts given.
    ///
    /// - Parameters:
    ///   - serverTrustEvaluators: An evaluator for each host name. `nil` leaves trust to the system.
    ///   - allServerTrustEvaluatorsMustSatisfy: Whether a host with no evaluator is refused. `false` leaves that host
    ///     to the system.
    public init(
        configuration: URLSessionConfiguration = .default,
        serverTrustEvaluators: [String: ServerTrustEvaluator]? = nil,
        allServerTrustEvaluatorsMustSatisfy: Bool = true
    ) {
        self.init(
            session: URLSession(configuration: configuration),
            delegate: ServerTrustDelegate(
                evaluators: serverTrustEvaluators,
                allEvaluatorsMustSatisfy: allServerTrustEvaluatorsMustSatisfy
            )
        )
    }
}

public extension NetworkServiceFoundation {
    /// Sends the request and returns the response for a status from 200 to 299.
    ///
    /// - Throws: A `NetworkError`. It holds the transport's error when the connection fails; the status, headers and
    ///   body when the server answers with another status; and the request alone when the response isn't HTTP.
    func send(_ request: URLRequest) async throws -> NetworkResponse {
        let response: URLResponse
        let data: Data

        do {
            (data, response) = try await session.data(for: request, delegate: delegate)
        } catch {
            throw NetworkError(request: request, internalError: error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError(request: request)
        }

        let headers = Self.headers(from: httpResponse.allHeaderFields)

        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError(request: request, data: data, headers: headers, statusCode: httpResponse.statusCode)
        }

        return NetworkResponse(
            data: data,
            headers: headers,
            statusCode: httpResponse.statusCode,
            request: request,
            response: response
        )
    }
}

extension NetworkServiceFoundation {
    /// The header fields of a response as strings. When two names read the same as strings, the last one read stays.
    static func headers(from fields: [AnyHashable: Any]) -> [String: String] {
        Dictionary(fields.map { ("\($0)", "\($1)") }) { _, last in last }
    }
}
