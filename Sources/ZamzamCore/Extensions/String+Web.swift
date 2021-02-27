//
//  String+Web.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Darwin

public extension String {

    /// Stripped out HTML to plain text.
    ///
    ///     "<p>This is <em>web</em> content with a <a href=\"http://example.com\">link</a>.</p>".htmlStripped // "This is web content with a link."
    ///
    var htmlStripped: String { replacing(regex: "<[^>]+>", with: "") }
}

public extension String {

    /// URL escaped string.
    func urlEncoded() -> String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }

    /// Readable string from a URL string.
    func urlDecoded() -> String {
        removingPercentEncoding ?? self
    }
}

public extension String {

    /// Decode an HTML string
    ///
    ///     let value = "<strong> 4 &lt; 5 &amp; 3 &gt; 2 .</strong> Price: 12 &#x20ac;.  &#64;"
    ///     value.htmlDecoded -> "<strong> 4 < 5 & 3 > 2 .</strong> Price: 12 €.  @"
    ///
    func htmlDecoded() -> String {
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
        func decodeNumeric(_ string: String, base: Int32) -> Character? {
            let code = UInt32(strtoul(string, nil, base))
            guard let scalar = UnicodeScalar(code) else { return nil }
            return Character(scalar)
        }

        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity: String) -> Character? {
            return entity.hasPrefix("&#x") || entity.hasPrefix("&#X")
                ? decodeNumeric(entity[3...] ?? "", base: 16)
                : entity.hasPrefix("&#")
                ? decodeNumeric(entity[2...] ?? "", base: 10)
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
