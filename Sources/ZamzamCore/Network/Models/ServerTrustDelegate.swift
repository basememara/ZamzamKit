//
//  ServerTrustDelegate.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-11-24.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSURLSession

/// The object that defines methods that URL session instances call on their delegates to handle session-level events, like session life cycle changes.
public class ServerTrustDelegate: NSObject, URLSessionTaskDelegate {
    private let evaluators: [String: ServerTrustEvaluator]?
    private let allEvaluatorsMustSatisfy: Bool

    public init(
        evaluators: [String: ServerTrustEvaluator]?,
        allEvaluatorsMustSatisfy: Bool
    ) {
        self.evaluators = evaluators
        self.allEvaluatorsMustSatisfy = allEvaluatorsMustSatisfy
    }

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
