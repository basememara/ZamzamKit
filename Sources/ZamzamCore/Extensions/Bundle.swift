//
//  NSBundle.swift
//  ZamzamCore
//
//  Created by Basem Emara on 3/4/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation.NSBundle

public extension Bundle {
    /// Gets the contents of the specified file.
    ///
    ///     Bundle.main.string(file: "Test.txt") // "This is a test. Abc 123.\n"
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
}

public extension Bundle {
    /// Returns the file URL for the resource identified by the specified name and file extension.
    /// - Parameters:
    ///   - name: The name of the resource file. If you specify nil, the method returns the first resource file it finds with the specified extension.
    ///   - ext: The extension of the resource file. If extension is an empty string or nil, the extension is assumed not to exist and the file URL is the first file encountered that exactly matches name.
    ///   - options: Options to control the reading of data from the contents.
    /// - Returns: The data read from the Bundle location.
    func data(forResource name: String?, withExtension ext: String?, options: Data.ReadingOptions = []) throws -> Data {
        guard let url = url(forResource: name, withExtension: ext) else {
            throw NSError(domain: bundleIdentifier ?? "", code: NSFileReadNoSuchFileError)
        }

        return try Data(contentsOf: url)
    }
}
