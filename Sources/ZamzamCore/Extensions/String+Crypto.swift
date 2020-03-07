//
//  String+Crypto.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation
import CommonCrypto

public extension String {
    
    /// Returns an encrypted version of the string in hex format
    func sha256() -> String? {
        // https://www.agnosticdev.com/content/how-use-commoncrypto-apis-swift-5
        guard let data = data(using: .utf8) else { return nil }
        
        /// Creates an array of unsigned 8 bit integers that contains 32 zeros
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        /// Performs digest calculation and places the result in the caller-supplied buffer for digest
        _ = data.withUnsafeBytes {
            CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }
        
        return Data(digest).hexString
    }
}
