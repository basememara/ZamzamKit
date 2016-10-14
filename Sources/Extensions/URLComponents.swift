//
//  NSURLComponentsExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension URLComponents {
    
    /**
     Add, update, or remove a query string parameter from the URL
     
     - parameter url:   the URL
     - parameter key:   the key of the query string parameter
     - parameter value: the value to replace the query string parameter, nil will remove item
     
     - returns: the URL with the mutated query string
     */
    public func addOrUpdateQueryStringParameter(_ key: String, value: String?) -> String {
        if var queryItems = queryItems {
            var urlComponent = self
            
            for (index, item) in queryItems.enumerated() {
                // Match query string key and update
                if item.name.lowercased() == key.lowercased() {
                    if let v = value {
                        queryItems[index] = URLQueryItem(name: key, value: v)
                    } else {
                        queryItems.remove(at: index)
                    }
                    urlComponent.queryItems = queryItems.count > 0 ? queryItems : nil
                    return urlComponent.string ?? ""
                }
            }
            
            // Key doesn't exist if reaches here
            if let v = value {
                // Add key to URL query string
                queryItems.append(URLQueryItem(name: key, value: v))
                urlComponent.queryItems = queryItems
                return urlComponent.string ?? ""
            }
        }
        
        return string ?? ""
    }
    
    /**
     Add, update, or remove a query string parameters from the URL
     
     - parameter url:   the URL
     - parameter values: the dictionary of query string parameters to replace
     
     - returns: the URL with the mutated query string
     */
    public func addOrUpdateQueryStringParameter(_ values: [String: String?]) -> String {
        var urlComponent = self
        
        values.forEach {
            urlComponent = URLComponents(string: urlComponent.addOrUpdateQueryStringParameter($0.key, value: $0.value)) ?? urlComponent
        }
        
        return urlComponent.string ?? ""
    }
    
    /**
     Removes a query string parameter from the URL
     
     - parameter url:   the URL
     - parameter key:   the key of the query string parameter
     
     - returns: the URL with the mutated query string
     */
    public func removeQueryStringParameter(_ key: String) -> String {
        return addOrUpdateQueryStringParameter(key, value: nil)
    }
    
}
