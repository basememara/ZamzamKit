//
//  Deprecated.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2018-09-20.
//  Copyright © 2018 Zamzam. All rights reserved.
//

public extension URLComponents {
    @available(*, unavailable, renamed: "URL.appendingQueryItem")
    func addOrUpdateQueryStringParameter(_ key: String, value: String?) -> String { return "" }
    
    @available(*, unavailable, renamed: "URL.appendingQueryItems")
    func addOrUpdateQueryStringParameter(_ values: [String: String?]) -> String { return "" }
    
    @available(*, unavailable, renamed: "URL.removeQueryItems")
    func removeQueryStringParameter(_ key: String) -> String { return "" }
}

public extension Sequence {
    
    @available(*, unavailable, message: "Use Swift 4.2 native `allSatisfy`")
    func all(_ predicate: (Iterator.Element) -> Bool) -> Bool {
        return !contains { !predicate($0) }
    }
}

public extension Array {
    
    @available(*, unavailable, message: "Use Swift 4.2 native `randomElement()`")
    func random() -> Element {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
}

public extension Hashable {
    
    @available(*, unavailable, message: "Use Swift 4.2 native `hash(into:)`")
    func combineHashes(_ hashes: [Int]) -> Int {
        return hashes.reduce(0, combineHashValues)
    }
    
    private func combineHashValues(_ initial: Int, _ other: Int) -> Int {
        // https://github.com/krzysztofzablocki/Sourcery/blob/master/Templates/AutoHashable.stencil
        // https://useyourloaf.com/blog/swift-hashable/
        let magic: UInt
        #if arch(x86_64) || arch(arm64)
        magic = 0x9e3779b97f4a7c15
        #elseif arch(i386) || arch(arm)
        magic = 0x9e3779b9
        #else
        magic = 0
        #endif
        var lhs = UInt(bitPattern: initial)
        let rhs = UInt(bitPattern: other)
        lhs ^= rhs &+ magic &+ (lhs << 6) &+ (lhs >> 2)
        return Int(bitPattern: lhs)
    }
}
