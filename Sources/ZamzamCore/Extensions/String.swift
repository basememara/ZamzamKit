//
//  String.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation.NSData

public extension String {
	/// Creates a string of random ASCII letters and digits after an optional prefix.
	///
	///     String(random: 10) // "zXWG4hSgL9"
	///     String(random: 4, prefix: "PIN-") // "PIN-uSjm"
	///
	/// A length of zero or less gives the prefix alone.
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
    /// Accesses the character at an offset from the start, or `nil` when the offset is out of bounds.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3] // "d"
    ///     value[99] // nil
    ///
    /// - Complexity: O(*n*), where *n* is the length of the string.
    subscript(_ position: Int) -> String? {
        guard 0..<count ~= position else { return nil }
        return String(self[index(startIndex, offsetBy: position)])
    }

    /// Accesses the characters in a closed range of offsets, clamped to the string, or `nil` when the range misses it.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3...6] // "def1"
    ///     value[3...99] // "def123456"
    ///     value[-3...2] // "Abc"
    ///     value[99...199] // nil
    subscript(_ range: ClosedRange<Int>) -> String? {
        guard range.upperBound >= 0 else { return nil }
        return self[range.lowerBound..<(range.upperBound < .max ? range.upperBound + 1 : .max)]
    }

    /// Accesses the characters in a half-open range of offsets, clamped to the string, or `nil` when the range misses it.
    ///
    ///     let value = "Abcdef123456"
    ///     value[3..<6] // "def"
    ///     value[3..<99] // "def123456"
    ///     value[-3..<2] // "Ab"
    ///     value[99..<199] // nil
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

    /// Returns the first `length` characters followed by `trailing`, or the whole string when it has no more than `length`.
    ///
    ///     "Abcdef123456".truncated(3) // "Abc..."
    ///     "Abcdef123456".truncated(6, trailing: "***") // "Abcdef***"
    ///
    /// A length of zero or less also returns the whole string.
    func truncated(_ length: Int, trailing: String = "...") -> String {
        guard length > 0, length < count else { return self }
        return prefix(length) + trailing
    }

    /// Returns the string with a separator between every group of `nth` characters.
    ///
    ///     "1234567890".separated(every: 2, with: "-") // "12-34-56-78-90"
    ///
    /// An `nth` below 1 or above the string's length returns the string unchanged.
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
    ///         .union(CharacterSet(charactersIn: "_"))
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
    /// Returns the Base64 encoding of the string's UTF-8 bytes.
    func base64Encoded() -> String {
        Data(utf8).base64EncodedString()
    }

    /// Returns the URL-safe Base64 encoding of the string's UTF-8 bytes, without padding.
    func base64URLEncoded() -> String {
        Data(utf8).base64URLEncodedString()
    }

    /// Returns the text a padded Base64 string holds, or `nil` when the string isn't Base64 or its bytes aren't UTF-8.
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

public extension String {
    private static let defaultDecoder = JSONDecoder()

    /// Returns a value of the type you specify, decoded from a JSON string.
    ///
    /// A `nil` decoder uses one plain `JSONDecoder` that every such call shares.
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
    /// The value as a `String`, for a `Substring`, a number or any other type a string can be made from.
    var string: String { String(self) }
}
