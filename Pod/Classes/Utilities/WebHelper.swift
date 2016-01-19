//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public struct WebHelper {
    
    // Mapping from XML/HTML character entity reference to character
    // From http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
    private let characterEntities : [String : Character] = [
        // XML predefined entities:
        "&quot;": "\"",
        "&amp;": "&",
        "&apos;": "'",
        "&lt;": "<",
        "&gt;": ">",
        
        // HTML character entity references:
        "&nbsp;": "\u{00a0}"
    ]
    
    //http://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift
    public func decodeHTML(value: String) -> String {
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(string : String, base : Int32) -> Character? {
            let code = UInt32(strtoul(string, nil, base))
            return Character(UnicodeScalar(code))
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(entity : String) -> Character? {
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(entity.substringFromIndex(entity.startIndex.advancedBy(3)), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.substringFromIndex(entity.startIndex.advancedBy(2)), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = value.startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = value.rangeOfString("&", range: position ..< value.endIndex) {
            result.appendContentsOf(value[position ..< ampRange.startIndex])
            position = ampRange.startIndex
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            if let semiRange = value.rangeOfString(";", range: position ..< value.endIndex) {
                let entity = value[position ..< semiRange.endIndex]
                position = semiRange.endIndex
                
                if let decoded = decode(entity) {
                    // Replace by decoded character:
                    result.append(decoded)
                } else {
                    // Invalid entity, copy verbatim:
                    result.appendContentsOf(entity)
                }
            } else {
                // No matching ';'.
                break
            }
        }
        // Copy remaining characters to `result`:
        result.appendContentsOf(value[position ..< value.endIndex])
        return result
    }
    
    /**
    Add, update, or remove a query string parameter from the URL
    
    - parameter url:   the URL
    - parameter key:   the key of the query string parameter
    - parameter value: the value to replace the query string parameter, nil will remove item
    
    - returns: the URL with the mutated query string
    */
    public func addOrUpdateQueryStringParameter(url: String, key: String, value: String?) -> String {
        if let components = NSURLComponents(string: url),
            var queryItems: [NSURLQueryItem] = (components.queryItems ?? []) {
                for (index, item) in queryItems.enumerate() {
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
    Add, update, or remove a query string parameters from the URL
    
    - parameter url:   the URL
    - parameter values: the dictionary of query string parameters to replace
    
    - returns: the URL with the mutated query string
    */
    public func addOrUpdateQueryStringParameter(url: String, values: [String: String]) -> String {
        var newUrl = url
        
        for item in values {
            newUrl = addOrUpdateQueryStringParameter(newUrl, key: item.0, value: item.1)
        }
        
        return newUrl
    }
    
    /**
    Removes a query string parameter from the URL
    
    - parameter url:   the URL
    - parameter key:   the key of the query string parameter
    
    - returns: the URL with the mutated query string
    */
    public func removeQueryStringParameter(url: String, key: String) -> String {
        return addOrUpdateQueryStringParameter(url, key: key, value: nil)
    }
    
}
