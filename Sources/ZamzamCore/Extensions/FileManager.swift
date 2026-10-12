//
//  FileManager.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import Foundation.NSFileManager
import Foundation.NSURL

#if !os(tvOS)
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
        if let filter = filter {
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
        urls(from: directory, filter: filter).map { $0.path }
    }
}

public extension FileManager {
    /// Retrieves a file and stores it in the caches directory under its own name, replacing any copy there.
    ///
    ///     let file = try await FileManager.default.download(from: url)
    ///
    /// - Parameter url: The HTTP URL to retrieve the file from.
    /// - Returns: Where the file was stored on disk.
    /// - Throws: A URL loading error, `URLError(.badServerResponse)` for a status outside 200–299, or a file error.
    func download(from url: URL) async throws -> URL {
        let (location, response) = try await URLSession.shared.download(from: url)

        if let response = response as? HTTPURLResponse, !(200..<300).contains(response.statusCode) {
            try? removeItem(at: location)
            throw URLError(.badServerResponse)
        }

        let destination = self.url(of: url.lastPathComponent, from: .cachesDirectory)
        try? removeItem(at: destination)
        try moveItem(at: location, to: destination)
        return destination
    }
}
#endif
