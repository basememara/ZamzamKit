//
//  StringExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension String {
    
    /**
     NSLocalizedString shorthand
     */
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /**
     Replaces a string using a regular expression pattern
     
     - parameter value: the value of the string
     - parameter pattern: the regular expression value
     - parameter replaceValue: the value to replace with
     
     - returns: the value with the replaced string
     */
    public func replaceRegEx(pattern: String, replaceValue: String) -> String {
        guard let regex: NSRegularExpression = try? NSRegularExpression(
            pattern: pattern,
            options: .CaseInsensitive) where self != "" else {
                return self
        }
        
        let length = self.characters.count
    
        return regex.stringByReplacingMatchesInString(self, options: [],
            range: NSMakeRange(0, length),
            withTemplate: replaceValue)
    }
    
    /**
     Decode an HTML string
     http://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift
     
     - parameter value: the encoded value of the HTML string
     
     - returns: the decoded string
     */
    public func decodeHTML() -> String {
        if self == "" {
            return self
        }
        
        var position = self.startIndex
        var result = ""
        
        // Mapping from XML/HTML character entity reference to character
        // From http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
        let characterEntities: [String: Character] = [
            // XML predefined entities:
            "&quot;": "\"",
            "&amp;": "&",
            "&apos;": "'",
            "&lt;": "<",
            "&gt;": ">",
            
            // HTML character entity references:
            "&nbsp;": "\u{00a0}"
        ]
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(string: String, base : Int32) -> Character? {
            let code = UInt32(strtoul(string, nil, base))
            return Character(UnicodeScalar(code))
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(entity: String) -> Character? {
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(entity.substringFromIndex(entity.startIndex.advancedBy(3)), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.substringFromIndex(entity.startIndex.advancedBy(2)), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self.rangeOfString("&", range: position ..< self.endIndex) {
            result.appendContentsOf(self[position ..< ampRange.startIndex])
            position = ampRange.startIndex
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            if let semiRange = self.rangeOfString(";", range: position ..< self.endIndex) {
                let entity = self[position ..< semiRange.endIndex]
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
        
        // Copy remaining characters to result
        result.appendContentsOf(self[position ..< self.endIndex])
        return result
    }
    
}