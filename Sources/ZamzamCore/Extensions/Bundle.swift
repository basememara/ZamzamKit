//
//  NSBundle.swift
//  ZamzamCore
//
//  Created by Basem Emara on 3/4/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation.NSBundle

public extension Bundle {
    /// Returns the text of a file in the bundle, or `nil` when the file is missing or isn't text in the encoding.
    ///
    ///     Bundle.main.string(file: "Test.txt") // "This is a test. Abc 123.\n"
    ///
    /// - Parameters:
    ///   - file: The file's name with its extension.
    ///   - directory: The bundle subdirectory to look in.
    func string(file: String, inDirectory directory: String? = nil, encoding: String.Encoding = .utf8) -> String? {
        guard let resourcePath = path(forResource: file, ofType: nil, inDirectory: directory) else { return nil }
        return try? String(contentsOfFile: resourcePath, encoding: encoding)
    }
}

public extension Bundle {
    /// Returns the contents of a resource in the bundle.
    ///
    /// - Throws: An `NSError` with the code `NSFileReadNoSuchFileError` when the bundle has no such resource, or
    ///   the error from reading the file.
    func data(forResource name: String?, withExtension ext: String?, options: Data.ReadingOptions = []) throws -> Data {
        guard let url = url(forResource: name, withExtension: ext) else {
            throw NSError(domain: bundleIdentifier ?? "", code: NSFileReadNoSuchFileError)
        }

        return try Data(contentsOf: url, options: options)
    }
}
