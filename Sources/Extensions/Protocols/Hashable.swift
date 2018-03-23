//
//  Hashable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/17/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

public extension Hashable {

    /// Allows multiple hash values to be combined to create a new unique hash value.
    ///
    /// - Parameter hashes: Array of hash values to combine.
    /// - Returns: The combined hash value.
    func combineHashes(_ hashes: [Int]) -> Int {
        return hashes.reduce(0, combineHashValues)
    }

    private func combineHashValues(_ initial: Int, _ other: Int) -> Int {
        // https://github.com/krzysztofzablocki/Sourcery/blob/master/Templates/AutoHashable.stencil
        // https://useyourloaf.com/blog/swift-hashable/
        #if arch(x86_64) || arch(arm64)
            let magic: UInt = 0x9e3779b97f4a7c15
        #elseif arch(i386) || arch(arm)
            let magic: UInt = 0x9e3779b9
        #endif
        var lhs = UInt(bitPattern: initial)
        let rhs = UInt(bitPattern: other)
        lhs ^= rhs &+ magic &+ (lhs << 6) &+ (lhs >> 2)
        return Int(bitPattern: lhs)
    }
}
