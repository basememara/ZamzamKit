//
//  NetworkServiceFoundationAsync.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-06-17.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLSession

public struct NetworkServiceFoundation: NetworkService {
    private let session: URLSession
    private let delegate: URLSessionTaskDelegate

    public init(
        configuration: URLSessionConfiguration = .default,
        serverTrustEvaluators: [String: ServerTrustEvaluator]? = nil,
        allServerTrustEvaluatorsMustSatisfy: Bool = true
    ) {
        self.session = URLSession(configuration: configuration)
        self.delegate = SessionTaskDelegate(
            serverTrustEvaluators: serverTrustEvaluators,
            allServerTrustEvaluatorsMustSatisfy: allServerTrustEvaluatorsMustSatisfy
        )
    }
}

public extension NetworkServiceFoundation {
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

        let headers: [String: String] = Dictionary(
            uniqueKeysWithValues: httpResponse.allHeaderFields.map { ("\($0)", "\($1)") }
        )

        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError(request: request, data: data, headers: headers, statusCode: httpResponse.statusCode)
        }

        let networkResponse = NetworkResponse(
            data: data,
            headers: headers,
            statusCode: httpResponse.statusCode,
            request: request,
            response: response
        )

        return networkResponse
    }
}

// MARK: - Delegates

private extension NetworkServiceFoundation {
    /// The object that defines methods that URL session instances call on their delegates to handle session-level events, like session life cycle changes.
    class SessionTaskDelegate: NSObject, URLSessionTaskDelegate {
        private let serverTrustEvaluators: [String: ServerTrustEvaluator]?
        private let allServerTrustEvaluatorsMustSatisfy: Bool

        init(
            serverTrustEvaluators: [String: ServerTrustEvaluator]?,
            allServerTrustEvaluatorsMustSatisfy: Bool
        ) {
            self.serverTrustEvaluators = serverTrustEvaluators
            self.allServerTrustEvaluatorsMustSatisfy = allServerTrustEvaluatorsMustSatisfy
        }

        func urlSession(
            _ session: URLSession,
            didReceive challenge: URLAuthenticationChallenge
        ) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
            let host = challenge.protectionSpace.host

            guard let serverTrustEvaluators = serverTrustEvaluators else {
                return (.performDefaultHandling, nil)
            }

            guard let serverTrust = challenge.protectionSpace.serverTrust,
                  challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else {
                      return (.performDefaultHandling, nil)
                  }

            guard let serverTrustEvaluator = serverTrustEvaluators[host] else {
                guard allServerTrustEvaluatorsMustSatisfy else {
                    return (.performDefaultHandling, nil)
                }

                return(.cancelAuthenticationChallenge, nil)
            }

            guard serverTrustEvaluator.valid(serverTrust, forHost: host) else {
                return (.cancelAuthenticationChallenge, nil)
            }

            return (.useCredential, URLCredential(trust: serverTrust))
        }
    }
}
