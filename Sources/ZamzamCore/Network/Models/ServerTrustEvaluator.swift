//
//  ServerTrustEvaluator.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-06-15.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation
import Security

/// A protocol describing the API used to evaluate server trusts.
public protocol ServerTrustEvaluator {
    /// Evaluates the given `SecTrust` value for the given `host`.
    ///
    /// - Parameters:
    ///   - trust: The `SecTrust` value to evaluate.
    ///   - host:  The host for which to evaluate the `SecTrust` value.
    ///
    /// - Returns: A `Bool` indicating whether the evaluator considers the `SecTrust` value valid for `host`.
    func valid(_ trust: SecTrust, forHost host: String) -> Bool
}

// MARK: - Pinned Certificate

/// Uses the pinned certificates to validate the server trust. The server trust is considered valid if one of the pinned
/// certificates match one of the server certificates. By validating both the certificate chain and host, certificate
/// pinning provides a very secure form of server trust validation mitigating most, if not all, MITM attacks.
/// Applications are encouraged to always validate the host and require a valid certificate chain in production.
public struct NetworkPinnedCertificateTrustEvaluator: ServerTrustEvaluator {
    private let certificates: [SecCertificate]
    private let acceptSelfSigned: Bool
    private let log: LogManager?

    public init(
        certificates: [SecCertificate],
        acceptSelfSigned: Bool = false,
        log: LogManager? = nil
    ) {
        self.certificates = certificates
        self.acceptSelfSigned = acceptSelfSigned
        self.log = log
    }

    public init(
        certificateURLs: [URL],
        acceptSelfSigned: Bool = false,
        log: LogManager? = nil
    ) {
        self.certificates = certificateURLs.compactMap { url in
            guard let data = try? Data(contentsOf: url) as CFData else { return nil }
            return SecCertificateCreateWithData(nil, data)
        }

        self.acceptSelfSigned = acceptSelfSigned
        self.log = log
    }
}

public extension NetworkPinnedCertificateTrustEvaluator {
    // Taken from: https://github.com/Alamofire/Alamofire
    func valid(_ trust: SecTrust, forHost host: String) -> Bool {
        guard !certificates.isEmpty else { return false }

        if acceptSelfSigned {
            // Add additional anchor certificates
            let status = SecTrustSetAnchorCertificates(trust, certificates as CFArray)

            guard status == errSecSuccess else {
                log?.error("Setting the self-signed anchor certificate failed while validating certificate pinning: \(status)")
                return false
            }

            // Trust only the set anchor certs
            let onlyStatus = SecTrustSetAnchorCertificatesOnly(trust, true)

            guard onlyStatus == errSecSuccess else {
                log?.error("Setting the self-signed anchor certificate failed while validating certificate pinning: \(status)")
                return false
            }
        }

        // Perform default and host validations
        guard valid(trust, for: [SecPolicyCreateSSL(true, nil)]),
            valid(trust, for: [SecPolicyCreateSSL(true, host as CFString)])
        else {
            return false
        }

        let serverCertificatesData = Set(
            (SecTrustCopyCertificateChain(trust) as? [SecCertificate])?
                .map { SecCertificateCopyData($0) as Data } ?? []
        )

        let pinnedCertificatesData = Set(certificates.map { SecCertificateCopyData($0) as Data })

        // Ensure pinned certificates in server data
        return !serverCertificatesData.isDisjoint(with: pinnedCertificatesData)
    }
}

extension NetworkPinnedCertificateTrustEvaluator {
    func valid(_ trust: SecTrust, for policies: [SecPolicy]) -> Bool {
        let status = SecTrustSetPolicies(trust, policies as CFTypeRef)

        guard status == errSecSuccess else {
            log?.error("Security trust failed for policies while validating certificate pinning: \(status)")
            return false
        }

        var error: CFError?

        guard SecTrustEvaluateWithError(trust, &error) else {
            log?.error("Security trust failed to evaluate certificate pinning: \(String(describing: error))")
            return false
        }

        return true
    }
}

// MARK: - Disabled

/// Disables all evaluation which in turn will always consider any server trust as valid.
///
/// **THIS EVALUATOR SHOULD NEVER BE USED IN PRODUCTION!**
public struct NetworkDisabledTrustEvaluator: ServerTrustEvaluator {
    public init() {}
    public func valid(_ trust: SecTrust, forHost host: String) -> Bool { true }
}
