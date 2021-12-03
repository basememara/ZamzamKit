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
    private let delegate: URLSessionTaskDelegate?

    public init(session: URLSession, delegate: URLSessionTaskDelegate? = nil) {
        self.session = session
        self.delegate = delegate
    }

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
