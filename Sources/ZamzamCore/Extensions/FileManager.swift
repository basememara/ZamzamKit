//
//  FileManager.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation.NSFileManager
import Foundation.NSURL

public extension FileManager {
    /// Get URL for the file.
    ///
    /// - Parameters:
    ///   - fileName: Name of file.
    ///   - directory: The directory of the file.
    /// - Returns: File URL from document directory.
    func url(of fileName: String, from directory: FileManager.SearchPathDirectory = .documentDirectory) -> URL {
        let root = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: root).appendingPathComponent(fileName)
    }

    /// Get URL's for files.
    ///
    /// - Parameters:
    ///   - directory: The directory of the files.
    ///   - filter: Specify filter to apply.
    /// - Returns: List of file URL's from document directory.
    func urls(from directory: FileManager.SearchPathDirectory = .documentDirectory, filter: ((URL) -> Bool)? = nil) -> [URL] {
        let root = urls(for: directory, in: .userDomainMask)[0]

        // Get the directory contents including folders
        guard var directoryUrls = try? contentsOfDirectory(at: root, includingPropertiesForKeys: nil) else { return [] }

        // Filter the directory contents if applicable
        if let filter {
            directoryUrls = directoryUrls.filter(filter)
        }

        return directoryUrls
    }
}

public extension FileManager {
    /// Get file system path for the file.
    ///
    /// - Parameters:
    ///   - fileName: Name of file.
    ///   - directory: The directory of the file.
    /// - Returns: File URL from document directory.
    func path(of fileName: String, from directory: FileManager.SearchPathDirectory = .documentDirectory) -> String {
        url(of: fileName, from: directory).path
    }

    /// Get file system paths for files.
    ///
    /// - Parameters:
    ///   - directory: The directory of the files.
    ///   - filter: Specify filter to apply.
    /// - Returns: List of file system paths from document directory.
    func paths(from directory: FileManager.SearchPathDirectory = .documentDirectory, filter: ((URL) -> Bool)? = nil) -> [String] {
        urls(from: directory, filter: filter).map(\.path)
    }
}
