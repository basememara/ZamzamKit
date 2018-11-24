//
//  NSFileManagerExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension FileManager {
    
    /// Get URL for the file.
    ///
    /// - Parameters:
    ///   - fileName: Name of file.
    ///   - directory: The directory of the file.
    /// - Returns: File URL from document directory.
    func url(of fileName: String, from directory: FileManager.SearchPathDirectory = .documentDirectory) -> URL {
        let root = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first!
        return URL(fileURLWithPath: root).appendingPathComponent(fileName)
    }
    
    /// Get URL's for files.
    ///
    /// - Parameters:
    ///   - directory: The directory of the files.
    ///   - filter: Specify filter to apply.
    /// - Returns: List of file URL's from document directory.
    func urls(from directory: FileManager.SearchPathDirectory = .documentDirectory, filter: ((URL) -> Bool)? = nil) -> [URL] {
        let root = urls(for: directory, in: .userDomainMask).first!
        
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
        return url(of: fileName, from: directory).path
    }
    
    /// Get file system paths for files.
    ///
    /// - Parameters:
    ///   - directory: The directory of the files.
    ///   - filter: Specify filter to apply.
    /// - Returns: List of file system paths from document directory.
    func paths(from directory: FileManager.SearchPathDirectory = .documentDirectory, filter: ((URL) -> Bool)? = nil) -> [String] {
        return urls(from: directory, filter: filter).map { $0.path }
    }
}

public extension FileManager {

    /// Retrieve a file remotely and persist to local disk.
    ///
    ///     FileManager.default.download(from: "http://example.com/test.pdf") { url, response, error in
    ///         // The `url` parameter represents location on local disk where remote file was downloaded.
    ///     }
    ///
    /// - Parameters:
    ///   - url: The HTTP URL to retrieve the file.
    ///   - completion: The completion handler to call when the load request is complete.
    func download(from url: String, completion: @escaping (URL?, URLResponse?, Error?) -> Void) {
        guard let nsURL = URL(string: url) else { return completion(nil, nil, ZamzamError.invalidData) }
        
        URLSession.shared.downloadTask(with: nsURL) { location, response, error in
            guard let location = location, error == nil else { return completion(nil, nil, error) }
            
            // Construct file destination
            let destination = self.url(of: nsURL.lastPathComponent, from: .cachesDirectory)
            
            // Delete local file if it exists to overwrite
            _ = try? self.removeItem(at: destination)
            
            // Store remote file locally
            do { try self.moveItem(at: location, to: destination) }
            catch { return completion(nil, nil, error) }
            
            completion(destination, response, error)
        }.resume()
    }
}
