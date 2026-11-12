//
//  URL.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation.NSURL

public extension URL {
    /// An invalid URL value.
    ///
    /// Use this constant when you want to indicate that a URL is invalid.
    static let invalidURL = URL(safeString: "https://")

    /// Non-optional initializer with documented fail output.
    ///
    ///     // Instead of: URL(string: "https://apple.com")!
    ///     let url: URL = URL(safeString: "https://apple.com")
    ///
    init(safeString string: String) {
        // https://ericasadun.com/2017/01/06/holy-war-forced-unwrapping-urls/
        guard let instance = URL(string: string) else {
            fatalError("Unconstructable URL: \(string)")
        }

        self = instance
    }
}

public extension URL {
    /// Returns a URL constructed by swapping the given path extension to self.
    ///
    ///     URL(fileURLWithPath: "/SomePath/SomeTests.swift")
    ///         .replacingPathExtension("json") // "/SomePath/SomeTests.json"
    ///
    /// - Parameter pathExtension: The extension to append.
    func replacingPathExtension(_ pathExtension: String) -> URL {
        deletingPathExtension().appendingPathExtension(pathExtension)
    }

    /// Returns a URL constructed by appending the suffix to the path component to self.
    ///
    ///     URL(fileURLWithPath: "/SomePath/SomeTests.json")
    ///         .appendingToFileName("123") // "/SomePath/SomeTests123.json"
    ///
    /// - Parameter string: Thesuffix to add.
    func appendingToFileName(_ string: String) -> URL {
        guard !string.isEmpty else { return self }

        return deletingLastPathComponent()
            .appendingPathComponent("\(deletingPathExtension().lastPathComponent)\(string)")
            .appendingPathExtension(pathExtension)
    }
}
