//
//  String.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation.NSData

public extension String {
    
    /// Create a new random string of given length.
    ///
    ///     String(random: 10) // "zXWG4hSgL9"
    ///     String(random: 4, prefix: "PIN-") // "PIN-uSjm"
	///
	/// - Parameter random: Number of characters in string.
	/// - Parameter prefix: Prepend to string.
	init(random: Int, prefix: String = "") {
        // https://github.com/SwifterSwift/SwifterSwift
		let base = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        
        self = random > 0
            ? (0..<random).reduce(prefix) { result, _ in result + "\(base.randomElement() ?? base[0])" }
            : prefix
	}
}

// MARK: - Subscript for ranges
// https://github.com/SwifterSwift/SwifterSwift

public extension String {
    
    /// Safely subscript string with index.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3] // "d"
    ///     value[99] // nil
    ///
    /// - Parameter i: index.
    subscript(position: Int) -> String? {
        guard 0..<count ~= position else { return nil }
        return String(self[index(startIndex, offsetBy: position)])
    }
    
    /// Safely subscript string within a closed range.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3...6] // "def1"
    ///     value[3...99] // nil
    ///
    /// - Parameter range: Closed range.
    subscript(range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex),
            let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else {
                return nil
        }
        
        return String(self[lowerIndex..<upperIndex])
    }
    
    /// Safely subscript string within a half-open range.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3..<6] // "def"
    ///
    /// - Parameter range: Half-open range.
    subscript(range: CountableRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex),
            let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else {
                return nil
        }
        
        return String(self[lowerIndex..<upperIndex])
    }
    
    /// Safely subscript string from the lower range to the end of the string.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3...] // "def123456"
    ///
    /// - Parameter range: A partial interval extending upward from a lower bound that forms a sequence of increasing values.
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
    var isEmail: Bool { match(regex: .emailRegEx) }
    
    /// Determine if the string contains only numbers.
    var isNumber: Bool { match(regex: .numberRegEx) }
    
    /// Determine if the string contains only letters.
    var isAlpha: Bool { match(regex: .alphaRegEx) }
    
    /// Determine if the string contains at least one letter and one number.
    var isAlphaNumeric: Bool { match(regex: .alphaNumericRegEx) }
}

public extension String {
    
    /// Returns a new string made by removing spaces or new lines from both ends.
    ///
    ///     " Abcdef123456 \n\r  ".trimmed // "Abcdef123456"
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    
    /// Truncated string limited to a given number of characters.
    ///
    ///     "Abcdef123456".truncated(3) // "Abc..."
    ///     "Abcdef123456".truncated(6, trailing: "***") // "Abcdef***"
    ///
    /// - Parameters:
    ///   - length: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string.
    /// - Returns: truncated string (this is an extr...).
    func truncated(_ length: Int, trailing: String = "...") -> String {
        guard 1..<count ~= length else { return self }
        return prefix(length) + trailing
    }
    
    /// Returns true if any character in the range is contained within.
    ///
    ///     "def".contains(CharacterSet(charactersIn: "Abcdef123456")) // true
    ///     "Xyz".contains(CharacterSet(charactersIn: "Abcdef123456")) // false
    func contains(_ elements: CharacterSet) -> Bool {
        rangeOfCharacter(from: elements) != nil
    }
    
    /// Injects a separator every nth characters.
    ///
    ///     "1234567890".separated(every: 2, with: "-") // "12-34-56-78-90"
    ///
    /// - Parameters:
    ///   - every: Number of characters to separate by.
    ///   - separator: The separator to inject.
    /// - Returns: The string with the injected separator.
    func separated(every nth: Int, with separator: String) -> String {
        guard !isEmpty, 1...count ~= nth else { return self }
        
        // https://stackoverflow.com/a/47566321
        return String(
            stride(from: 0, to: count, by: nth)
                .map { Array(Array(self)[$0..<min($0 + nth, count)]) }
                .joined(separator: separator)
        )
    }
    
    /// Returns a new string made by removing the characters contained in a given set.
    ///
    ///     let string = """
    ///         { 0         1
    ///         2                  34
    ///         56       7             8
    ///         9
    ///         }
    ///         """
    ///
    ///     string.strippingCharacters(in: .whitespacesAndNewlines)
    ///     // {0123456789}
    ///
    /// - Parameters:
    ///   - set: A set of character values to remove.
    /// - Returns: The string with the removed characters.
    func strippingCharacters(in set: CharacterSet) -> String {
        replacingCharacters(in: set, with: "")
    }
    
    /// Returns a new string made by replacing the characters contained in a given set with another string.
    ///
    ///     let set = CharacterSet.alphanumerics
    ///         .insert(charactersIn: "_")
    ///         .inverted
    ///
    ///     let string = """
    ///         _abcdefghijklmnopqrstuvwxyz
    ///         ABCDEFGHIJKLMNOPQRSTUVWXYZ
    ///         0{1 2<3>4@5#6`7~8?9,0
    ///
    ///         1
    ///         """
    ///
    ///     string.replacingCharacters(in: set, with: "_")
    ///     //_abcdefghijklmnopqrstuvwxyz_ABCDEFGHIJKLMNOPQRSTUVWXYZ_0_1_2_3_4_5_6_7_8_9_0__1
    ///
    /// - Parameters:
    ///   - set: A set of character values to replace.
    ///   - string: A string to replace with.
    /// - Returns: The string with the replaced characters.
    func replacingCharacters(in set: CharacterSet, with string: String) -> String {
        components(separatedBy: set).joined(separator: string)
    }
    
    /// Returns a new string in which the last occurrence of a target string is replaced by another given string.
    func replacingLastOccurrence(of target: String, with replacement: String) -> String {
        guard let range = self.range(of: target, options: .backwards) else { return self }
        return replacingOccurrences(of: target, with: replacement, range: range)
    }
}

// MARK: - Regular Expression

public extension String {
    
    /// Matches a string using a regular expression pattern.
    ///
    ///     "1234567890".match(regex: "^[0-9]+?$") // true
    ///     "abc123xyz".match(regex: "^[A-Za-z]+$") // false
    ///
    /// - Parameters:
    ///   - regex: the regular expression pattern
    /// - Returns: whether the regex matches in the string
    func match(regex pattern: String) -> Bool {
        range(of: pattern, options: [.regularExpression]) != nil
    }
    
    /// Returns a new string in which all occurrences of a
    /// regular expression pattern in a specified range of
    /// the string are replaced by another given string.
    ///
    ///     "aa1bb22cc3d888d4ee5".replacing(regex: "\\d", with: "*") // "aa*bb**cc*d***d*ee*"
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

// MARK: - Encoding

public extension String {
    private static let defaultDecoder = JSONDecoder()
    
    /// Returns a value of the type you specify, decoded from a JSON string.
    func decode<T: Decodable>(
        using encoding: Self.Encoding = .utf8,
        with decoder: JSONDecoder? = nil
    ) -> T? {
        guard let data = data(using: encoding) else { return nil }
        let decoder = decoder ?? Self.defaultDecoder
        return try? decoder.decode(T.self, from: data)
    }
}

public extension String {
    
    /// Encode a string to Base64. Default encoding is UTF8.
    func base64Encoded() -> String {
        Data(utf8).base64EncodedString()
    }
    
    /// URL safe encode a string to Base64. Default encoding is UTF8.
    func base64URLEncoded() -> String {
        Data(utf8).base64URLEncodedString()
    }
    
    /// Decode a string from Base64. Default decoding is UTF8.
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

// MARK: - Crypto

public extension String {
    
    /// Returns an encrypted data of the string
    func sha256() -> Data {
        Data(utf8).sha256()
    }
}

// MARK: - Types

public extension Optional where Wrapped == String {
    
    /// A Boolean value indicating whether a string is `nil` or has no characters.
    var isNilOrEmpty: Bool { self?.isEmpty ?? true }
}

public extension Substring {
    
    /// A string value representation of the string slice.
    var string: String { String(self) }
}
