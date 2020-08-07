//
//  URL.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation.NSURL

public extension URL {
    
    /// Non-optional initializer with documented fail output.
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

public extension URL {
    
    /// Returns a URL constructed by appending the given query string parameter to self.
    ///
    ///     let url = URL(string: "https://example.com?abc=123&lmn=tuv&xyz=987")
    ///     url?.appendingQueryItem("def", value: "456") // "https://example.com?abc=123&lmn=tuv&xyz=987&def=456"
    ///     url?.appendingQueryItem("xyz", value: "999") // "https://example.com?abc=123&lmn=tuv&xyz=999"
    ///
    /// - Parameters:
    ///   - name: The key of the query string parameter.
    ///   - value: The value to replace the query string parameter, nil will remove item.
    /// - Returns: The URL with the appended query string.
    func appendingQueryItem(_ name: String, value: Any?) -> URL {
        // https://basememara.com/updating-query-string-parameters-in-swift/
        guard var urlComponents = URLComponents(string: absoluteString) else {
            return self
        }
        
        urlComponents.queryItems = urlComponents.queryItems?
            .filter { $0.name.caseInsensitiveCompare(name) != .orderedSame } ?? []
        
        // Skip if nil value
        if let value = value {
            urlComponents.queryItems?.append(URLQueryItem(name: name, value: "\(value)"))
        }
        
        return urlComponents.url ?? self
    }
    
    /// Returns a URL constructed by appending the given query string parameters to self.
    ///
    ///     let url = URL(string: "https://example.com?abc=123&lmn=tuv&xyz=987")
    ///     url?.appendingQueryItems([
    ///         "def": "456",
    ///         "jkl": "777",
    ///         "abc": "333",
    ///         "lmn": nil
    ///     ]) // "https://example.com?xyz=987&def=456&abc=333&jkl=777"
    ///
    /// - Parameter contentsOf: A dictionary of query string parameters to modify.
    /// - Returns: The URL with the appended query string.
    func appendingQueryItems(_ contentsOf: [String: Any?]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString), !contentsOf.isEmpty else {
            return self
        }
        
        let keys = contentsOf.keys.map { $0.lowercased() }
        
        urlComponents.queryItems = urlComponents.queryItems?
            .filter { !keys.contains($0.name.lowercased()) } ?? []
        
        urlComponents.queryItems?.append(contentsOf: contentsOf.compactMap {
            guard let value = $0.value else { return nil } //Skip if nil
            return URLQueryItem(name: $0.key, value: "\(value)")
        })
        
        return urlComponents.url ?? self
    }
    
    /// Returns a URL constructed by removing the given query string parameter to self.
    ///
    ///     let url = URL(string: "https://example.com?abc=123&lmn=tuv&xyz=987")
    ///     url?.removeQueryItem("xyz") // "https://example.com?abc=123&lmn=tuv"
    ///
    /// - Parameter name: The key of the query string parameter.
    /// - Returns: The URL with the mutated query string.
    func removeQueryItem(_ name: String) -> URL {
        appendingQueryItem(name, value: nil)
    }
}

public extension URL {
    
    /// Query a URL from a parameter name.
    ///
    ///     let url = URL(string: "https://example.com?abc=123&lmn=tuv&xyz=987")
    ///     url?.queryItem("aBc") // "123"
    ///     url?.queryItem("lmn") // "tuv"
    ///     url?.queryItem("yyy") // nil
    ///
    /// - Parameter name: The key of the query string parameter.
    /// - Returns: The value of the query string parameter.
    func queryItem(_ name: String) -> String? {
        // https://stackoverflow.com/q/41421686
        URLComponents(string: absoluteString)?
            .queryItems?
            .first { $0.name.caseInsensitiveCompare(name) == .orderedSame }?
            .value
    }
}
