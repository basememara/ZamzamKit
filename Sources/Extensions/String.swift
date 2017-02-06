//
//  StringExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension String {
    
    /// Create a new random string of given length.
    /// https://github.com/SwifterSwift/SwifterSwift
	///
	/// - Parameter random: Number of characters in string.
	/// - Parameter prefix: Prepend to string.
	public init(random: Int, prefix: String = "") {
		guard random > 0 else { self = prefix; return }
		let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
		self = (0..<random).reduce(prefix) {
			let randomIndex = arc4random_uniform(UInt32(base.characters.count))
            return $0.0 + "\(base[base.index(base.startIndex, offsetBy: IndexDistance(randomIndex))])"
        }
	}
}

public extension String {
    
    /// Check if string is valid email format.
    var isEmail: Bool {
        return match(ZamzamConstants.RegEx.EMAIL)
    }

	/// Check if string contains only numbers.
    var isNumber: Bool {
        return match(ZamzamConstants.RegEx.NUMBER)
    }

	/// Check if string contains only letters.
    var isAlpha: Bool {
        return match(ZamzamConstants.RegEx.ALPHA)
    }

	/// Check if string contains at least one letter and one number.
    var isAlphaNumeric: Bool {
        return match(ZamzamConstants.RegEx.ALPHANUMERIC)
    }

    /// String with no spaces or new lines in beginning and end.
    var trimmed: String {
        return trimmingCharacters(in: .whitespaces)
    }
}

// MARK: - Localization
public extension String {
    
    /// NSLocalizedString shorthand
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}


// MARK: - Regular Expression
public extension String {

    /**
     Replaces a string using a regular expression pattern.
     
     - parameter value: the value of the string
     - parameter pattern: the regular expression value
     - parameter replacement: the value to replace with
     
     - returns: the value with the replaced string
     */
    func replace(regex: String, with replacement: String, caseSensitive: Bool = false) -> String {
        guard !self.isEmpty else { return self }
        
        // Determine options
        var options: CompareOptions = [.regularExpression]
        if !caseSensitive {
            options.insert(.caseInsensitive)
        }
        
        return replacingOccurrences(of: regex, with: replacement, options: options)
    }
    
    /// Matches a string using a regular expression pattern.
    ///
    /// - Parameters:
    ///   - pattern: the regular expression value
    ///   - caseSensitive: case-sensitive search
    /// - Returns: whether the regex matches in the string
    func match(_ pattern: String, caseSensitive: Bool = false) -> Bool {
        // Determine options
        var options: CompareOptions = [.regularExpression]
        if !caseSensitive {
            options.insert(.caseInsensitive)
        }
        
        return range(of: pattern, options: options) != nil
    }

}

public extension String {

    /// Truncated string (limited to a given number of characters).
	///
	/// - Parameters:
	///   - toLength: maximum number of characters before cutting.
	///   - trailing: string to add at the end of truncated string.
	/// - Returns: truncated string (this is an extr...).
	public func truncated(_ length: Int, trailing: String = "...") -> String {
        guard 1..<characters.count ~= length else { return self }
		return substring(to: index(startIndex, offsetBy: length)) + trailing
	}


    /// Determines if the given value is contained in the string.
    ///
    /// - Parameter find: The value to search for.
    /// - Returns: True if the value exists in the string, false otherwise.
    func contains(_ find: String) -> Bool {
        return range(of: find) != nil
    }
}

// MARK: - Web utilities
public extension String {
	
	/// Readable string from a URL string.
	var urlDecoded: String {
		return removingPercentEncoding ?? self
	}
	
	/// URL escaped string.
	var urlEncoded: String {
		return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
	}
    
    /// Stripped out HTML to plain text.
    var htmlStripped: String {
        return replace(regex: "<[^>]+>", with: "")
    }
    
    /// Decode an HTML string
    /// http://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift
    var htmlDecoded: String {
        guard !isEmpty else { return self }
        
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
        func decodeNumeric(_ string: String, base : Int32) -> Character? {
            let code = UInt32(strtoul(string, nil, base))
            return Character(UnicodeScalar(code)!)
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity: String) -> Character? {
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(entity.substring(from: entity.characters.index(entity.startIndex, offsetBy: 3)), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.substring(from: entity.characters.index(entity.startIndex, offsetBy: 2)), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self.range(of: "&", range: position ..< self.endIndex) {
            result.append(self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            if let semiRange = self.range(of: ";", range: position ..< self.endIndex) {
                let entity = self[position ..< semiRange.upperBound]
                position = semiRange.upperBound
                
                if let decoded = decode(entity) {
                    // Replace by decoded character:
                    result.append(decoded)
                } else {
                    // Invalid entity, copy verbatim:
                    result.append(entity)
                }
            } else {
                // No matching ';'.
                break
            }
        }
        
        // Copy remaining characters to result
        result.append(self[position ..< self.endIndex])
        return result
    }
}
