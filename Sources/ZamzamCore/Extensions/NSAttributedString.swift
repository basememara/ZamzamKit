//
//  NSAttributedString.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2018-12-22.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    
    /// The full series of characters.
    var range: NSRange { NSRange(location: 0, length: length) }
    
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

// MARK: - String

public extension String {
    
    /// The full series of characters.
    var range: NSRange { NSRange(location: 0, length: count) }
    
    /// A string that has associated attributes (such as visual style, hyperlinks, or accessibility data) for portions of its text.
    var attributed: NSAttributedString { NSAttributedString(string: self) }
    
    /// A mutable string object that also contains attributes (such as visual style, hyperlinks, or accessibility data) associated with various portions of its text content.
    var mutableAttributed: NSMutableAttributedString { NSMutableAttributedString(string: self) }
    
    /// Adds the given collection of attributes to the characters in the specified range.
    ///
    ///     "Hello world".mutableAttributed([
    ///         .underlineStyle: NSUnderlineStyle.single.rawValue,
    ///         .foregroundColor: UIColor.blue
    ///     ])
    ///
    /// - Parameters:
    ///   - attributes: A dictionary containing the attributes to add.
    ///   - range: The range of characters to which the specified attributes apply.
    /// - Returns: The mutated attributed string.
    func mutableAttributed(_ attributes: [NSAttributedString.Key: Any], range: NSRange? = nil) -> NSMutableAttributedString {
        let mutable = mutableAttributed
        mutable.addAttributes(attributes, range: range ?? self.range)
        return mutable
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
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
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
    static func + (lhs: NSAttributedString, rhs: String) -> NSMutableAttributedString {
        lhs + rhs.attributed
    }
}
