//
//  Deprecated.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2018-11-01.
//  Copyright © 2018 Zamzam. All rights reserved.
//

public extension String {
    
    @available(*, unavailable, renamed: "String.replacing(regex:)")
    func replace(regex: String, with replacement: String, caseSensitive: Bool = false) -> String {
        return replacing(regex: regex, with: replacement, caseSensitive: caseSensitive)
    }
    
    @available(*, unavailable, renamed: "String.match(regex:)")
    func match(_ pattern: String, caseSensitive: Bool = false) -> Bool {
        return match(regex: pattern)
    }
}
