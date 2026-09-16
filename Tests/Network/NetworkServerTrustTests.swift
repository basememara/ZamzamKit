//
//  NetworkServerTrustTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2020-06-16.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
@testable import ZamzamCore

// The SecTrust fixtures are shared statics that the tests mutate through their anchors.
@Suite(.serialized)
struct NetworkServerTrustTests {}

extension NetworkServerTrustTests {
    @Test
    func thatAnchoredRootCertificatePassesSSLValidationWithRootInTrust() {
        // Given
        let certificates = [SecCertificate.leafDNSNameAndURI, .intermediateCA1, .alamofireRootCA]
        let trust = SecTrust.make(from: certificates).assignRootCertificateAsLoneAnchor()
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: certificates)

        // When
        let result = evaluator.valid(trust, forHost: "test.alamofire.org")

        // Then
        #expect(result)
    }

    @Test
    func thatAnchoredRootCertificatePassesSSLValidationWithoutRootInTrust() {
        // Given
        let trust = SecTrust.leafDNSNameAndURI.assignRootCertificateAsLoneAnchor()
        let policies = [SecPolicyCreateSSL(true, "test.alamofire.org" as CFString)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        #expect(result)
    }

    @Test
    func thatCertificateMissingDNSNameFailsSSLValidation() {
        // Given
        let trust = SecTrust.leafMissingDNSNameAndURI.assignRootCertificateAsLoneAnchor()
        let policies = [SecPolicyCreateSSL(true, "test.alamofire.org" as CFString)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        #expect(!(result))
    }

    @Test
    func thatWildcardCertificatePassesSSLValidation() {
        // Given
        let trust = SecTrust.leafWildcard.assignRootCertificateAsLoneAnchor() // *.alamofire.org
        let policies = [SecPolicyCreateSSL(true, "test.alamofire.org" as CFString)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        #expect(result)
    }

    @Test
    func thatDNSNameCertificatePassesSSLValidation() {
        // Given
        let trust = SecTrust.leafValidDNSName.assignRootCertificateAsLoneAnchor()
        let policies = [SecPolicyCreateSSL(true, "test.alamofire.org" as CFString)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        #expect(result)
    }

    @Test
    func thatURICertificateFailsSSLValidation() {
        // Given
        let trust = SecTrust.leafValidURI.assignRootCertificateAsLoneAnchor()
        let policies = [SecPolicyCreateSSL(true, "test.alamofire.org" as CFString)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        #expect(!(result))
    }

    @Test
    func thatMultipleDNSNamesCertificatePassesSSLValidationForAllEntries() {
        // Given
        let trust = SecTrust.leafMultipleDNSNames.assignRootCertificateAsLoneAnchor()
        let policies = [
            SecPolicyCreateSSL(true, "test.alamofire.org" as CFString),
            SecPolicyCreateSSL(true, "blog.alamofire.org" as CFString),
            SecPolicyCreateSSL(true, "www.alamofire.org" as CFString)
        ]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        #expect(result)
    }

    @Test
    func thatPassingNilForHostParameterAllowsCertificateMissingDNSNameToPassSSLValidation() {
        // Given
        let trust = SecTrust.leafMissingDNSNameAndURI.assignRootCertificateAsLoneAnchor()
        let policies = [SecPolicyCreateSSL(true, nil)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        #expect(result)
    }

    @Test
    func thatExpiredCertificateFailsSSLValidation() {
        // Given
        let trust = SecTrust.leafExpired.assignRootCertificateAsLoneAnchor()
        let policies = [SecPolicyCreateSSL(true, "test.alamofire.org" as CFString)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        #expect(!(result))
    }
}

extension NetworkServerTrustTests {
    @Test
    func thatPinningLeafCertificateNotInCertificateChainFailsEvaluationWithHostValidation() {
        // Given
        let host = "test.alamofire.org"
        let serverTrust = SecTrust.leafValidDNSName
        let certificates = [SecCertificate.leafSignedByCA2]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: certificates)

        // When
        let result = evaluator.valid(serverTrust, forHost: host)

        // Then
        #expect(!(result))
    }

    @Test
    func thatPinningIntermediateCertificateNotInCertificateChainFailsEvaluationWithHostValidation() {
        // Given
        let host = "test.alamofire.org"
        let serverTrust = SecTrust.leafValidDNSName
        let certificates = [SecCertificate.intermediateCA1]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: certificates)

        // When
        let result = evaluator.valid(serverTrust, forHost: host)

        // Then
        #expect(!(result))
    }

    @Test
    func thatPinningExpiredLeafCertificateFailsEvaluationWithHostValidation() {
        // Given
        let host = "test.alamofire.org"
        let serverTrust = SecTrust.leafExpired
        let certificates = [SecCertificate.leafExpired]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: certificates)

        // When
        let result = evaluator.valid(serverTrust, forHost: host)

        // Then
        #expect(!(result))
    }

    @Test
    func thatPinningIntermediateCertificateWithExpiredLeafCertificateFailsEvaluationWithHostValidation() {
        // Given
        let host = "test.alamofire.org"
        let serverTrust = SecTrust.leafExpired
        let certificates = [SecCertificate.intermediateCA2]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: certificates)

        // When
        let result = evaluator.valid(serverTrust, forHost: host)

        // Then
        #expect(!(result))
    }
}

extension NetworkServerTrustTests {
    @Test
    func thatPinnedLeafCertificatePassesEvaluationWithSelfSignedSupportAndHostValidation() {
        // Given
        let host = "test.alamofire.org"
        let serverTrust = SecTrust.leafValidDNSName
        let certificates = [SecCertificate.leafValidDNSName]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(
            certificates: certificates,
            acceptSelfSigned: true
        )

        // When
        let result = evaluator.valid(serverTrust, forHost: host)

        // Then
        #expect(result)
    }

    @Test
    func thatPinnedIntermediateCertificatePassesEvaluationWithSelfSignedSupportAndHostValidation() {
        // Given
        let host = "test.alamofire.org"
        let serverTrust = SecTrust.leafValidDNSName
        let certificates = [SecCertificate.intermediateCA2]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(
            certificates: certificates,
            acceptSelfSigned: true
        )

        // When
        let result = evaluator.valid(serverTrust, forHost: host)

        // Then
        #expect(result)
    }

    @Test
    func thatPinnedRootCertificatePassesEvaluationWithSelfSignedSupportAndHostValidation() {
        // Given
        let host = "test.alamofire.org"
        let serverTrust = SecTrust.leafValidDNSName
        let certificates = [SecCertificate.alamofireRootCA]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(
            certificates: certificates,
            acceptSelfSigned: true
        )

        // When
        let result = evaluator.valid(serverTrust, forHost: host)

        // Then
        #expect(result)
    }
}

// MARK: - Extensions

private extension SecCertificate {
    // Root Certificates
    static let alamofireRootCA = make(from: "alamofire.org/alamofire-root-ca.cer")

    // Intermediate Certificates
    static let intermediateCA1 = make(from: "alamofire.org/alamofire-signing-ca1.cer")
    static let intermediateCA2 = make(from: "alamofire.org/alamofire-signing-ca2.cer")

    // Leaf Certificates - Signed by CA1
    static let leafWildcard = make(from: "alamofire.org/wildcard.alamofire.org.cer")
    static let leafMultipleDNSNames = make(from: "alamofire.org/multiple-dns-names.cer")
    static let leafSignedByCA1 = make(from: "alamofire.org/signed-by-ca1.cer")
    static let leafDNSNameAndURI = make(from: "alamofire.org/test.alamofire.org.cer")

    // Leaf Certificates - Signed by CA2
    static let leafExpired = make(from: "alamofire.org/expired.cer")
    static let leafMissingDNSNameAndURI = make(from: "alamofire.org/missing-dns-name-and-uri.cer")
    static let leafSignedByCA2 = make(from: "alamofire.org/signed-by-ca2.cer")
    static let leafValidDNSName = make(from: "alamofire.org/valid-dns-name.cer")
    static let leafValidURI = make(from: "alamofire.org/valid-uri.cer")

    static func make(from path: String) -> SecCertificate {
        let url = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("Certificates")
            .appendingPathComponent(path)

        let data = try! Data(contentsOf: url) as CFData // swiftlint:disable:this force_try
        return SecCertificateCreateWithData(nil, data)! // swiftlint:disable:this force_unwrapping
    }
}

private extension SecTrust {
    // MARK: Leaf Trusts - Signed by CA1

    static let leafWildcard = make(from: [
        .leafWildcard,
        .intermediateCA1,
        .alamofireRootCA
    ])

    static let leafMultipleDNSNames = make(from: [
        .leafMultipleDNSNames,
        .intermediateCA1,
        .alamofireRootCA
    ])

    static let leafSignedByCA1 = make(from: [
        .leafSignedByCA1,
        .intermediateCA1,
        .alamofireRootCA
    ])

    static let leafDNSNameAndURI = make(from: [
        .leafDNSNameAndURI,
        .intermediateCA1,
        .alamofireRootCA
    ])

    // MARK: Leaf Trusts - Signed by CA2

    static let leafExpired = make(from: [
        .leafExpired,
        .intermediateCA2,
        .alamofireRootCA
    ])

    static let leafMissingDNSNameAndURI = make(from: [
        .leafMissingDNSNameAndURI,
        .intermediateCA2,
        .alamofireRootCA
    ])

    static let leafSignedByCA2 = make(from: [
        .leafSignedByCA2,
        .intermediateCA2,
        .alamofireRootCA
    ])

    static let leafValidDNSName = make(from: [
        .leafValidDNSName,
        .intermediateCA2,
        .alamofireRootCA
    ])

    static let leafValidURI = make(from: [
        .leafValidURI,
        .intermediateCA2,
        .alamofireRootCA
    ])

    // MARK: Invalid Trusts

    static let leafValidDNSNameMissingIntermediate = make(from: [
        .leafValidDNSName,
        .alamofireRootCA
    ])

    static let leafValidDNSNameWithIncorrectIntermediate = make(from: [
        .leafValidDNSName,
        .intermediateCA1,
        .alamofireRootCA
    ])

    // MARK: Helpers

    static func make(from certificates: [SecCertificate]) -> SecTrust {
        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        SecTrustCreateWithCertificates(certificates as CFTypeRef, policy, &trust)
        return trust! // swiftlint:disable:this force_unwrapping
    }

    func assignRootCertificateAsLoneAnchor() -> Self {
        SecTrustSetAnchorCertificates(self, [SecCertificate.alamofireRootCA] as CFArray)
        SecTrustSetAnchorCertificatesOnly(self, true)
        return self
    }
}
