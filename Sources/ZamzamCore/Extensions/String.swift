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
// https://stackoverflow.com/a/38215613/

public extension String {
    /// Safely subscript string with index.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3] // "d"
    ///     value[99] // nil
    ///
    /// - Parameter i: index.
    subscript(_ position: Int) -> String? {
        guard 0..<count ~= position else { return nil }
        return String(self[index(startIndex, offsetBy: position)])
    }

    /// Safely subscript string within a closed range.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3...6] // "def1"
    ///     value[3...99] // "def123456"
    ///     value[-3...2] // "Abc"
    ///     value[99...199] // nil
    ///
    /// - Parameter range: Closed range.
    subscript(_ range: ClosedRange<Int>) -> String? {
        guard range.upperBound >= 0 else { return nil }
        return self[range.lowerBound..<(range.upperBound < .max ? range.upperBound + 1 : .max)]
    }

    /// Safely subscript string within a half-open range.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3..<6] // "def"
    ///     value[3..<99] // "def123456"
    ///     value[-3..<2] // "Ab"
    ///     value[99..<199] // nil
    ///
    /// - Parameter range: Half-open range.
    subscript(_ range: CountableRange<Int>) -> String? {
        let lowerBound = max(0, range.lowerBound)
        guard lowerBound <= range.upperBound else { return nil }

        guard let lowerIndex = index(startIndex, offsetBy: lowerBound, limitedBy: endIndex),
              let upperIndex = index(lowerIndex, offsetBy: range.upperBound - lowerBound, limitedBy: endIndex)
        else {
            guard lowerBound < count else { return nil }
            return dropFirst(lowerBound).string
        }

        return String(self[lowerIndex..<upperIndex])
    }
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
        guard length > 0, length < count else { return self }
        return prefix(length) + trailing
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
        Array(self)
            .chunked(into: nth)
            .map { String($0) }
            .joined(separator: separator)
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

// MARK: - Decoding / Encoding

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

public extension String {
    private static let defaultDecoder = JSONDecoder()

    /// Returns a value of the type you specify, decoded from a JSON string.
    func decode<T: Decodable>(using encoding: Self.Encoding = .utf8, with decoder: JSONDecoder? = nil) throws -> T {
        let decoder = decoder ?? Self.defaultDecoder
        return try decoder.decode(T.self, from: self, using: encoding)
    }
}

// MARK: - Types

public extension Optional where Wrapped == String {
    /// A Boolean value indicating whether a string is `nil` or has no characters.
    var isNilOrEmpty: Bool { self?.isEmpty ?? true }

    /// A Boolean value indicating whether a string is `nil` or has no characters or blanks.
    var isNilOrBlank: Bool { isNilOrEmpty || self?.allSatisfy(\.isWhitespace) ?? true }
}

public extension LosslessStringConvertible {
    /// A string value representation of the string slice.
    var string: String { String(self) }
}
