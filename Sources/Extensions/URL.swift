//
//  NSURLComponentsExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension URL {
    
    /**
     Add, update, or remove a query string parameter from the URL
     
     - parameter url:   the URL
     - parameter key:   the key of the query string parameter
     - parameter value: the value to replace the query string parameter, nil will remove item
     
     - returns: the URL with the mutated query string
     */
    func appendingQueryItem(_ name: String, value: Any?) -> String {
        guard var urlComponents = URLComponents(string: absoluteString) else {
            return absoluteString
        }
        
        urlComponents.queryItems = urlComponents.queryItems?
            .filter { $0.name.lowercased() != name.lowercased() } ?? []
        
        // Skip if nil value
        if let value = value {
            urlComponents.queryItems?.append(URLQueryItem(name: name, value: "\(value)"))
        }
        
        return urlComponents.string ?? absoluteString
    }
    
    /**
     Add, update, or remove a query string parameters from the URL
     
     - parameter url:   the URL
     - parameter values: the dictionary of query string parameters to replace
     
     - returns: the URL with the mutated query string
     */
    func appendingQueryItems(_ contentsOf: [String: Any?]) -> String {
        guard var urlComponents = URLComponents(string: absoluteString), !contentsOf.isEmpty else {
            return absoluteString
        }
        
        let keys = contentsOf.keys.map { $0.lowercased() }
        
        urlComponents.queryItems = urlComponents.queryItems?
            .filter { !keys.contains($0.name.lowercased()) } ?? []
        
        urlComponents.queryItems?.append(contentsOf: contentsOf.compactMap {
            guard let value = $0.value else { return nil } //Skip if nil
            return URLQueryItem(name: $0.key, value: "\(value)")
        })
        
        return urlComponents.string ?? absoluteString
    }
    
    /**
     Removes a query string parameter from the URL
     
     - parameter url:   the URL
     - parameter key:   the key of the query string parameter
     
     - returns: the URL with the mutated query string
     */
    func removeQueryItem(_ name: String) -> String {
        return appendingQueryItem(name, value: nil)
    }
}

// Deprecation notices, will be removed future version
public extension URLComponents {
    @available(*, unavailable, renamed: "URL.appendingQueryItem")
    func addOrUpdateQueryStringParameter(_ key: String, value: String?) -> String { return "" }
    
    @available(*, unavailable, renamed: "URL.appendingQueryItems")
    func addOrUpdateQueryStringParameter(_ values: [String: String?]) -> String { return "" }
    
    @available(*, unavailable, renamed: "URL.removeQueryItems")
    func removeQueryStringParameter(_ key: String) -> String { return "" }
}
