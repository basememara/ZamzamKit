//
//  NetworkServerTrustTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2020-06-16.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import XCTest
@testable import ZamzamCore

final class NetworkServerTrustTests: XCTestCase {}

extension NetworkServerTrustTests {
    func testThatAnchoredRootCertificatePassesSSLValidationWithRootInTrust() {
        // Given
        let certificates = [SecCertificate.leafDNSNameAndURI, .intermediateCA1, .alamofireRootCA]
        let trust = SecTrust.make(from: certificates).assignRootCertificateAsLoneAnchor()
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: certificates)

        // When
        let result = evaluator.valid(trust, forHost: "test.alamofire.org")

        // Then
        XCTAssertTrue(result, "trust should be valid")
    }

    func testThatAnchoredRootCertificatePassesSSLValidationWithoutRootInTrust() {
        // Given
        let trust = SecTrust.leafDNSNameAndURI.assignRootCertificateAsLoneAnchor()
        let policies = [SecPolicyCreateSSL(true, "test.alamofire.org" as CFString)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        XCTAssertTrue(result, "trust should be valid")
    }

    func testThatCertificateMissingDNSNameFailsSSLValidation() {
        // Given
        let trust = SecTrust.leafMissingDNSNameAndURI.assignRootCertificateAsLoneAnchor()
        let policies = [SecPolicyCreateSSL(true, "test.alamofire.org" as CFString)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        XCTAssertFalse(result, "trust should not be valid")
    }

    func testThatWildcardCertificatePassesSSLValidation() {
        // Given
        let trust = SecTrust.leafWildcard.assignRootCertificateAsLoneAnchor() // *.alamofire.org
        let policies = [SecPolicyCreateSSL(true, "test.alamofire.org" as CFString)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        XCTAssertTrue(result, "trust should be valid")
    }

    func testThatDNSNameCertificatePassesSSLValidation() {
        // Given
        let trust = SecTrust.leafValidDNSName.assignRootCertificateAsLoneAnchor()
        let policies = [SecPolicyCreateSSL(true, "test.alamofire.org" as CFString)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        XCTAssertTrue(result, "trust should be valid")
    }

    func testThatURICertificateFailsSSLValidation() {
        // Given
        let trust = SecTrust.leafValidURI.assignRootCertificateAsLoneAnchor()
        let policies = [SecPolicyCreateSSL(true, "test.alamofire.org" as CFString)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        XCTAssertFalse(result, "trust should not be valid")
    }

    func testThatMultipleDNSNamesCertificatePassesSSLValidationForAllEntries() {
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
        XCTAssertTrue(result, "trust should not be valid")
    }

    func testThatPassingNilForHostParameterAllowsCertificateMissingDNSNameToPassSSLValidation() {
        // Given
        let trust = SecTrust.leafMissingDNSNameAndURI.assignRootCertificateAsLoneAnchor()
        let policies = [SecPolicyCreateSSL(true, nil)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        XCTAssertTrue(result, "trust should not be valid")
    }

    func testThatExpiredCertificateFailsSSLValidation() {
        // Given
        let trust = SecTrust.leafExpired.assignRootCertificateAsLoneAnchor()
        let policies = [SecPolicyCreateSSL(true, "test.alamofire.org" as CFString)]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: [])

        // When
        let result = evaluator.valid(trust, for: policies)

        // Then
        XCTAssertFalse(result, "trust should not be valid")
    }
}

extension NetworkServerTrustTests {
    func testThatPinningLeafCertificateNotInCertificateChainFailsEvaluationWithHostValidation() {
        // Given
        let host = "test.alamofire.org"
        let serverTrust = SecTrust.leafValidDNSName
        let certificates = [SecCertificate.leafSignedByCA2]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: certificates)

        // When
        let result = evaluator.valid(serverTrust, forHost: host)

        // Then
        XCTAssertFalse(result, "server trust should not pass evaluation")
    }

    func testThatPinningIntermediateCertificateNotInCertificateChainFailsEvaluationWithHostValidation() {
        // Given
        let host = "test.alamofire.org"
        let serverTrust = SecTrust.leafValidDNSName
        let certificates = [SecCertificate.intermediateCA1]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: certificates)

        // When
        let result = evaluator.valid(serverTrust, forHost: host)

        // Then
        XCTAssertFalse(result, "server trust should not pass evaluation")
    }

    func testThatPinningExpiredLeafCertificateFailsEvaluationWithHostValidation() {
        // Given
        let host = "test.alamofire.org"
        let serverTrust = SecTrust.leafExpired
        let certificates = [SecCertificate.leafExpired]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: certificates)

        // When
        let result = evaluator.valid(serverTrust, forHost: host)

        // Then
        XCTAssertFalse(result, "server trust should not pass evaluation")
    }

    func testThatPinningIntermediateCertificateWithExpiredLeafCertificateFailsEvaluationWithHostValidation() {
        // Given
        let host = "test.alamofire.org"
        let serverTrust = SecTrust.leafExpired
        let certificates = [SecCertificate.intermediateCA2]
        let evaluator = NetworkPinnedCertificateTrustEvaluator(certificates: certificates)

        // When
        let result = evaluator.valid(serverTrust, forHost: host)

        // Then
        XCTAssertFalse(result, "server trust should not pass evaluation")
    }
}

extension NetworkServerTrustTests {
    func testThatPinnedLeafCertificatePassesEvaluationWithSelfSignedSupportAndHostValidation() {
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
        XCTAssertTrue(result, "server trust should pass evaluation")
    }

    func testThatPinnedIntermediateCertificatePassesEvaluationWithSelfSignedSupportAndHostValidation() {
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
        XCTAssertTrue(result, "server trust should pass evaluation")
    }

    func testThatPinnedRootCertificatePassesEvaluationWithSelfSignedSupportAndHostValidation() {
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
        XCTAssertTrue(result, "server trust should pass evaluation")
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
