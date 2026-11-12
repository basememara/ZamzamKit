//
//  ServerTrustDelegate.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-11-24.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLSession

/// A URL session delegate that answers server trust challenges with an evaluator for each host.
public final class ServerTrustDelegate: NSObject, URLSessionTaskDelegate, @unchecked Sendable {
    private let evaluators: [String: ServerTrustEvaluator]?
    private let allEvaluatorsMustSatisfy: Bool

    /// Creates a delegate.
    ///
    /// - Parameters:
    ///   - evaluators: An evaluator for each host name. `nil` leaves every challenge to the system.
    ///   - allEvaluatorsMustSatisfy: Whether a host with no evaluator is refused. `false` leaves that host to the system.
    public init(
        evaluators: [String: ServerTrustEvaluator]?,
        allEvaluatorsMustSatisfy: Bool
    ) {
        self.evaluators = evaluators
        self.allEvaluatorsMustSatisfy = allEvaluatorsMustSatisfy
    }

    /// Accepts the server's trust when the host's evaluator finds it valid and cancels the challenge when it doesn't.
    /// Challenges of any other kind go to the system.
    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge
    ) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        let host = challenge.protectionSpace.host

        guard let evaluators else {
            return (.performDefaultHandling, nil)
        }

        guard let serverTrust = challenge.protectionSpace.serverTrust,
              challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else {
                  return (.performDefaultHandling, nil)
              }

        guard let evaluator = evaluators[host] else {
            guard allEvaluatorsMustSatisfy else {
                return (.performDefaultHandling, nil)
            }

            return(.cancelAuthenticationChallenge, nil)
        }

        guard evaluator.valid(serverTrust, forHost: host) else {
            return (.cancelAuthenticationChallenge, nil)
        }

        return (.useCredential, URLCredential(trust: serverTrust))
    }
    }
