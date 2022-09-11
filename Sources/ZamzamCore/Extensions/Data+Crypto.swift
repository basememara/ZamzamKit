//
//  String+Crypto.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import CryptoKit
import Foundation.NSData

public extension Data {
    /// Returns an encrypted version of the data.
    func sha256() -> Self {
        SHA256.hash(data: self).data
    }
}

// MARK: - Extensions

public extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }
}
