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
    ///
    ///     String(random: 10) -> "zXWG4hSgL9"
    ///     String(random: 4, prefix: "PIN-") -> "PIN-uSjm"
	///
	/// - Parameter random: Number of characters in string.
	/// - Parameter prefix: Prepend to string.
	public init(random: Int, prefix: String = "") {
        // https://github.com/SwifterSwift/SwifterSwift
		let base = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        
        self = random > 0
            ? (0..<random).reduce(prefix) { result, next in result + "\(base.randomElement()!)" }
            : prefix
	}
}

// MARK: - Subscript for ranges
// https://github.com/SwifterSwift/SwifterSwift

public extension String {
    
    /// Safely subscript string with index.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3] -> "d"
    ///     value[99] -> nil
    ///
    /// - Parameter i: index.
    subscript(i: Int) -> String? {
        guard 0..<count ~= i else { return nil }
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    /// Safely subscript string within a half-open range.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3..<6] -> "def"
    ///     value[3...6] -> "def1"
    ///     value[3...] -> "def123456"
    ///     value[3...99] -> nil
    ///
    /// - Parameter range: Half-open range.
    subscript(range: CountableRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex),
            let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else {
                return nil
        }
        
        return String(self[lowerIndex..<upperIndex])
    }
    
    /// Safely subscript string within a closed range.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3..<6] -> "def"
    ///     value[3...6] -> "def1"
    ///     value[3...] -> "def123456"
    ///     value[3...99] -> nil
    ///
    /// - Parameter range: Closed range.
    subscript(range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex),
            let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else {
                return nil
        }
        
        return String(self[lowerIndex..<upperIndex])
    }
    
    /// Safely subscript string from the lower range to the end of the string.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3..<6] -> "def"
    ///     value[3...6] -> "def1"
    ///     value[3...] -> "def123456"
    ///     value[3...99] -> nil
    ///
    /// - Parameter range: A partial interval extending upward from a lower bound that forms a sequence of increasing values..
    subscript(range: CountablePartialRangeFrom<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[lowerIndex..<endIndex])
    }
}

public extension String {
    private static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    private static let numberRegEx = "^[0-9]+?$"
    private static let alphaRegEx = "^[A-Za-z]+$"
    private static let alphaNumericRegEx = "^[A-Za-z0-9]+$"
    
    /// Determine if the string is valid email format.
    var isEmail: Bool {
        return match(regex: String.emailRegEx)
    }
    
    /// Determine if the string contains only numbers.
    var isNumber: Bool {
        return match(regex: String.numberRegEx)
    }
    
    /// Determine if the string contains only letters.
    var isAlpha: Bool {
        return match(regex: String.alphaRegEx)
    }
    
    /// Determine if the string contains at least one letter and one number.
    var isAlphaNumeric: Bool {
        return match(regex: String.alphaNumericRegEx)
    }
}

public extension String {
    
    /// Returns a new string made by removing spaces or new lines from both ends.
    ///
    ///     " Abcdef123456 \n\r  ".trimmed -> "Abcdef123456"
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Truncated string limited to a given number of characters.
    ///
    ///     "Abcdef123456".truncated(3) -> "Abc..."
    ///     "Abcdef123456".truncated(6, trailing: "***") -> "Abcdef***"
    ///
    /// - Parameters:
    ///   - length: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string.
    /// - Returns: truncated string (this is an extr...).
    func truncated(_ length: Int, trailing: String = "...") -> String {
        guard 1..<count ~= length else { return self }
        return prefix(length) + trailing
    }
    
    /// Determines if the given value is contained in the string.
    ///
    ///     "1234567890".contains("567") -> true
    ///     "abc123xyz".contains("ghi") -> false
    ///
    /// - Parameter find: The value to search for.
    /// - Returns: True if the value exists in the string, false otherwise.
    func contains(_ find: String) -> Bool {
        return range(of: find) != nil
    }
    
    /// Injects a separator every nth characters.
    ///
    ///     "1234567890".separate(every: 2, with: "-") -> "12-34-56-78-90"
    ///
    /// - Parameters:
    ///   - every: Number of characters to separate by.
    ///   - separator: The separator to inject.
    /// - Returns: The string with the injected separator.
    func separate(every: Int, with separator: String) -> String {
        guard !isEmpty, 1...count ~= every else { return self }
        
        // https://stackoverflow.com/a/47566321/235334
        return String(
            stride(from: 0, to: count, by: every)
                .map { Array(Array(self)[$0..<min($0 + every, count)]) }
                .joined(separator: separator)
        )
    }
}

// MARK: - Regular Expression

public extension String {
    
    /// Matches a string using a regular expression pattern.
    ///
    ///     "1234567890".match(regex: "^[0-9]+?$") -> true
    ///     "abc123xyz".match(regex: "^[A-Za-z]+$") -> false
    ///
    /// - Parameters:
    ///   - regex: the regular expression pattern
    /// - Returns: whether the regex matches in the string
    func match(regex pattern: String) -> Bool {
        let options: CompareOptions = [.regularExpression]
        return range(of: pattern, options: options) != nil
    }
    
    /// Returns a new string in which all occurrences of a
    /// regular expression pattern in a specified range of
    /// the string are replaced by another given string.
    ///
    ///     "aa1bb22cc3d888d4ee5".replacing(regex: "\\d", with: "*") -> "aa*bb**cc*d***d*ee*"
    ///
    /// - Parameters:
    ///   - regex: the regular expression pattern
    ///   - replacement: the value to replace with
    ///   - caseSensitive: specify for case insensitive option
    /// - Returns: the value with the replaced string
    func replacing(regex pattern: String, with replacement: String, caseSensitive: Bool = false) -> String {
        guard !isEmpty else { return self }
        
        // Determine options
        var options: CompareOptions = [.regularExpression]
        
        if !caseSensitive {
            options.insert(.caseInsensitive)
        }
        
        return replacingOccurrences(of: pattern, with: replacement, options: options)
    }
}

// MARK: - Web utilities

public extension String {
    
    /// URL escaped string.
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
	
	/// Readable string from a URL string.
	var urlDecoded: String {
		return removingPercentEncoding ?? self
	}
    
    /// Stripped out HTML to plain text.
    ///
    ///     "<p>This is <em>web</em> content with a <a href=\"http://example.com\">link</a>.</p>".htmlStripped -> "This is web content with a link."
    var htmlStripped: String {
        return replacing(regex: "<[^>]+>", with: "")
    }
    
    /// Decode an HTML string
    var htmlDecoded: String {
        // http://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift
        guard !isEmpty else { return self }
        
        var position = startIndex
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
            return entity.hasPrefix("&#x") || entity.hasPrefix("&#X")
                ? decodeNumeric(entity[3...]!, base: 16)
                : entity.hasPrefix("&#")
                    ? decodeNumeric(entity[2...]!, base: 10)
                : characterEntities[entity]
        }
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = range(of: "&", range: position..<endIndex) {
            result.append(String(self[position..<ampRange.lowerBound]))
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            guard let semiRange = range(of: ";", range: position..<endIndex) else { break }
            
            let entity = self[position..<semiRange.upperBound]
            position = semiRange.upperBound
            
            if let decoded = decode(String(entity)) {
                // Replace by decoded character:
                result.append(decoded)
            } else {
                // Invalid entity, copy verbatim:
                result.append(String(entity))
            }
        }
        
        // Copy remaining characters to result
        result.append(String(self[position..<endIndex]))
        return result
    }
}

public extension String {
    
    /// Encode a string to Base64
    var base64Encoded: String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /// Decode a string from Base64
    var base64Decoded: String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// URL safe encode a string to Base64
    var base64URLEncoded: String {
        return base64Encoded
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
    }
}

public extension Substring {
    
    /// A string value representation of the string slice.
    var string: String {
        return String(self)
    }
}

public extension Optional where Wrapped == String {

    /// A Boolean value indicating whether a string is `nil` or has no characters.
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
