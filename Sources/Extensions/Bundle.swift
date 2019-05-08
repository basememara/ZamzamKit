//
//  NSBundle.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/4/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Bundle {
    private class TempClassForBundle {}
    
    /// A representation of the code and resources stored in ZamzamKit bundle directory on disk.
    static let zamzamKit = Bundle(for: TempClassForBundle.self)
}

public extension Bundle {
    
    /// Gets the contents of the specified file.
    ///
    ///     Bundle.main.string(file: "Test.txt") -> "This is a test. Abc 123.\n"
    ///
    /// - Parameters:
    ///   - file: Name of file to retrieve contents from.
    ///   - directory: The name of the bundle subdirectory.
    ///   - encoding: The encoding of the Unicode characters. The default is UTF8.
    /// - Returns: Contents of file.
    func string(file: String, inDirectory directory: String? = nil, encoding: String.Encoding = .utf8) -> String? {
        guard let resourcePath = path(forResource: file, ofType: nil, inDirectory: directory) else { return nil }
        return try? String(contentsOfFile: resourcePath, encoding: encoding)
    }
    
    /// Gets the contents of the specified plist file.
    ///
    ///     let values: [[String: Any]] = Bundle.main.array(plist: "Settings.plist")
    ///     values.first?["MyString1"] as? String -> "My string value 1."
    ///     values.first?["MyNumber1"] as? Int -> 123
    ///     values.first?["MyBool1"] as? Bool -> false
    ///     values.first?["MyDate1"] as? Date -> 2018-11-21 15:40:03 +0000
    ///
    /// - Parameters:
    ///   - plist: The property list where the array is declared.
    ///   - directory: The name of the bundle subdirectory.
    /// - Returns: Array of values of the property list file.
    func array<T>(plist: String, inDirectory directory: String? = nil) -> [T] {
        guard let resourcePath = path(forResource: plist, ofType: nil, inDirectory: directory),
            let contents = NSArray(contentsOfFile: resourcePath) as? [T] else {
                return []
        }
        
        return contents
    }
    
    /// Gets the contents of the specified plist file.
    ///
    ///     let values = Bundle.main.contents(plist: "Settings.plist")
    ///     values["MyString1"] as? String -> "My string value 1."
    ///     values["MyNumber1"] as? Int -> 123
    ///     values["MyBool1"] as? Bool -> false
    ///     values["MyDate1"] as? Date -> 2018-11-21 15:40:03 +0000
    ///
    /// - Parameters:
    ///   - plist: The property list where key and values are declared.
    ///   - directory: The name of the bundle subdirectory.
    /// - Returns: Dictionary of values of the property list file.
    func contents(plist: String, inDirectory directory: String? = nil) -> [String: Any] {
        guard let resourcePath = path(forResource: plist, ofType: nil, inDirectory: directory),
            let contents = NSDictionary(contentsOfFile: resourcePath) as? [String: Any] else {
                return [:]
        }
        
        return contents
    }
}
