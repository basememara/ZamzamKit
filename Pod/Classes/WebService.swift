//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public class WebService: NSObject {
    
    public func decodeHTML(value: String) -> String {
        let encodedData = value.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions: [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        let attributedString = NSAttributedString(
            data: encodedData,
            options: attributedOptions,
            documentAttributes: nil,
            error: nil)!
        
        return attributedString.string
    }
    
    /**
    Add, update, or remove a query string item from the URL
    
    :param: url   the URL
    :param: key   the key of the query string item
    :param: value the value to replace the query string item, nil will remove item
    
    :returns: the URL with the mutated query string
    */
    public func addOrUpdateQueryString(url: String, key: String, value: String?) -> String {
        if let components = NSURLComponents(string: url),
            var queryItems = (components.queryItems ?? []) as? [NSURLQueryItem] {
                println("sdvs")
                for (index, item) in enumerate(queryItems) {
                    // Match query string key and update
                    if item.name == key {
                        if let v = value {
                            queryItems[index] = NSURLQueryItem(name: key, value: v)
                        } else {
                            queryItems.removeAtIndex(index)
                        }
                        components.queryItems = queryItems.count > 0
                            ? queryItems : nil
                        return components.string!
                    }
                }
                
                // Key doesn't exist if reaches here
                if let v = value {
                    // Add key to URL query string
                    queryItems.append(NSURLQueryItem(name: key, value: v))
                    components.queryItems = queryItems
                    return components.string!
                }
        }
        
        return url
    }
    
    /**
    Removes a query string item from the URL
    
    :param: url   the URL
    :param: key   the key of the query string item
    
    :returns: the URL with the mutated query string
    */
    public func removeQueryString(url: String, key: String) -> String {
        return addOrUpdateQueryString(url, key: key, value: nil)
    }
    
}
