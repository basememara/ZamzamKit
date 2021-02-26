//
//  NetworkServiceFoundation.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-02-27.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLSession

public struct NetworkServiceFoundation: NetworkService {
    private let session: URLSession

    public init(
        configuration: URLSessionConfiguration = .default,
        serverTrustEvaluators: [String: ServerTrustEvaluator]? = nil,
        allServerTrustEvaluatorsMustSatisfy: Bool = true
    ) {
        let delegate = SessionDelegate(
            serverTrustEvaluators: serverTrustEvaluators,
            allServerTrustEvaluatorsMustSatisfy: allServerTrustEvaluatorsMustSatisfy
        )

        self.session = URLSession(
            configuration: configuration,
            delegate: delegate,
            delegateQueue: nil
        )
    }
}

public extension NetworkServiceFoundation {
    func send(_ request: URLRequest, completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        session.dataTask(
            with: request,
            completionHandler: completion
        ).resume()
    }
}

// MARK: - Delegates

private extension NetworkServiceFoundation {
    /// The object that defines methods that URL session instances call on their delegates to handle session-level events, like session life cycle changes.
    class SessionDelegate: NSObject, URLSessionDelegate {
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
            didReceive challenge: URLAuthenticationChallenge,
            completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
        ) {
            let host = challenge.protectionSpace.host

            guard let serverTrustEvaluators = serverTrustEvaluators else {
                completionHandler(.performDefaultHandling, nil)
                return
            }

            guard let serverTrust = challenge.protectionSpace.serverTrust,
                challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else {
                    completionHandler(.performDefaultHandling, nil)
                    return
            }

            guard let serverTrustEvaluator = serverTrustEvaluators[host] else {
                guard allServerTrustEvaluatorsMustSatisfy else {
                    completionHandler(.performDefaultHandling, nil)
                    return
                }

                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }

            guard serverTrustEvaluator.valid(serverTrust, forHost: host) else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }

            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
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
        completionHandler: @escaping (Result<NetworkResponse, NetworkError>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: request) { (data, response, error) in
            if let error = error {
                let networkError = NetworkError(request: request, internalError: error)
                DispatchQueue.main.async { completionHandler(.failure(networkError)) }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let networkError = NetworkError(request: request)
                DispatchQueue.main.async { completionHandler(.failure(networkError)) }
                return
            }

            let headers: [String: String] = Dictionary(
                uniqueKeysWithValues: httpResponse.allHeaderFields.map { ("\($0)", "\($1)") }
            )

            guard let data = data else {
                let networkError = NetworkError(request: request, headers: headers, statusCode: httpResponse.statusCode)
                DispatchQueue.main.async { completionHandler(.failure(networkError)) }
                return
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                let networkError = NetworkError(request: request, data: data, headers: headers, statusCode: httpResponse.statusCode)
                DispatchQueue.main.async { completionHandler(.failure(networkError)) }
                return
            }

            DispatchQueue.main.async {
                let networkResponse = NetworkResponse(
                    data: data,
                    headers: headers,
                    statusCode: httpResponse.statusCode,
                    request: request
                )

                completionHandler(.success(networkResponse))
            }
        }
    }
}
