//
//  NSAttributedString.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2018-12-22.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    
    /// The full series of characters.
    var range: NSRange {
        return NSRange(location: 0, length: length)
    }
    
    /// Dictionary of the attributes applied across the whole string.
    var attributes: [NSAttributedString.Key: Any] {
        guard length > 0 else { return [:] }
        return attributes(at: 0, effectiveRange: nil)
    }
}

// MARK: - Mutable attributed string

public extension NSMutableAttributedString {
    
    /// Adds an attribute with the given name and value to the characters in the specified range.
    ///
    /// - Parameters:
    ///   - name: A string specifying the attribute name.
    ///   - value: The attribute value associated with name.
    func addAttribute(_ name: NSAttributedString.Key, value: Any) {
        addAttribute(name, value: value, range: range)
    }
    
    /// Adds the given collection of attributes to the attributed string.
    ///
    /// - Parameter attrs: A dictionary containing the attributes to add.
    func addAttributes(_ attrs: [NSAttributedString.Key: Any]) {
        addAttributes(attrs, range: range)
    }
}

// MARK: - Operators

public extension NSAttributedString {
    
    /// Add attributed strings together and return a new instance.
    ///
    /// - Parameters:
    ///   - lhs: Attributed string to add.
    ///   - rhs: Attributed string to add.
    /// - Returns: New instance with added attributed strings.
    static func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
        let mutable = NSMutableAttributedString(attributedString: lhs)
        mutable.append(rhs)
        return mutable
    }
    
    /// Add attributed string to string and return a new instance.
    ///
    /// - Parameters:
    ///   - lhs: Attributed string to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with add attributed string and string.
    static func +(lhs: NSAttributedString, rhs: String) -> NSMutableAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
}

