//
//  NSURLComponentsExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension URL {
    
    /// Returns a URL constructed by appending the given query string parameter to self.
    ///
    ///     let url = URL(string: "https://example.com?abc=123&lmn=tuv&xyz=987")
    ///     url?.appendingQueryItem("def", value: "456") -> "https://example.com?abc=123&lmn=tuv&xyz=987&def=456"
    ///     url?.appendingQueryItem("xyz", value: "999") -> "https://example.com?abc=123&lmn=tuv&xyz=999"
    ///
    /// - Parameters:
    ///   - name: The key of the query string parameter.
    ///   - value: The value to replace the query string parameter, nil will remove item.
    /// - Returns: The URL with the appended query string.
    func appendingQueryItem(_ name: String, value: Any?) -> URL {
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
    ///     ]) -> "https://example.com?xyz=987&def=456&abc=333&jkl=777"
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
    ///     url?.removeQueryItem("xyz") -> "https://example.com?abc=123&lmn=tuv"
    ///
    /// - Parameter name: The key of the query string parameter.
    /// - Returns: The URL with the mutated query string.
    func removeQueryItem(_ name: String) -> URL {
        return appendingQueryItem(name, value: nil)
    }
}

public extension URL {
    
    /// Query a URL from a parameter name.
    ///
    ///     let url = URL(string: "https://example.com?abc=123&lmn=tuv&xyz=987")
    ///     url?.queryItem("aBc") -> "123"
    ///     url?.queryItem("lmn") -> "tuv"
    ///     url?.queryItem("yyy") -> nil
    ///
    /// - Parameter name: The key of the query string parameter.
    /// - Returns: The value of the query string parameter.
    func queryItem(_ name: String) -> String? {
        // https://stackoverflow.com/q/41421686
        return URLComponents(string: absoluteString)?
            .queryItems?
            .first{ $0.name.caseInsensitiveCompare(name) == .orderedSame }?
            .value
    }
}
