//
//  String+Crypto.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import CommonCrypto
import Foundation.NSData

public extension Data {

    /// Returns an encrypted version of the data.
    func sha256() -> Data {
        // Creates an array of unsigned 8 bit integers that contains 32 zeros
        // https://www.agnosticdev.com/content/how-use-commoncrypto-apis-swift-5
        // https://stackoverflow.com/questions/25388747/sha256-in-swift
        var buffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))

        // Performs digest calculation and places the result in the caller-supplied buffer for digest
        _ = withUnsafeBytes {
            CC_SHA256($0.baseAddress, CC_LONG(count), &buffer)
        }

        return Data(buffer)
    }
}
