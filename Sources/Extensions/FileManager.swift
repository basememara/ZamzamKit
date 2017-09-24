//
//  NSFileManagerExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension FileManager {
    
    /**
     Get file system path for document file
     
     - parameter fileName: Name of file
     
     - returns: File URL from document directory
     */
    func url(of fileName: String, from directory: FileManager.SearchPathDirectory = .documentDirectory) -> URL {
        let root = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first!
        return URL(fileURLWithPath: root).appendingPathComponent(fileName)
    }
    
    /**
     Get URL for document file
     
     - parameter fileName: Name of file
     
     - returns: File path from document directory
     */
    func path(of fileName: String, from directory: FileManager.SearchPathDirectory = .documentDirectory) -> String {
        return url(of: fileName, from: directory).path
    }
    
    /**
     Get URLs for document file
     
     - parameter filter: Specify filter to apply
     
     - returns: List of file URLs from document directory
     */
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
    
    /**
     Get file system paths for document file
     
     - parameter filter: Specify filter to apply
     
     - returns: List of file paths from document directory
     */
    func paths(from directory: FileManager.SearchPathDirectory = .documentDirectory, filter: ((URL) -> Bool)? = nil) -> [String] {
        return urls(from: directory, filter: filter).map { $0.path }
    }
}


public extension FileManager {

    /// Retrieve a file remotely and persist to local disk.
    ///
    /// - Parameters:
    ///   - url: The HTTP URL to retrieve the file.
    ///   - complete: The completion handler to call when the load request is complete.
    func download(from url: String, complete: @escaping (URL?, URLResponse?, Error?) -> Void) {
        guard let nsURL = URL(string: url) else { return complete(nil, nil, ZamzamError.invalidData) }
        
        URLSession.shared.downloadTask(with: nsURL) {
            let response = $1
            let error = $2
            
            guard error == nil, let location = $0 else { return complete(nil, nil, error) }
            
            // Construct file destination and prepare location
            let destination = self.url(of: nsURL.lastPathComponent, from: .cachesDirectory)
            _ = try? self.removeItem(at: destination)
            
            // Store remote file locally
            do { try self.moveItem(at: location, to: destination) }
            catch { return complete(nil, nil, error) }
            
            complete(destination, response, error)
        }.resume()
    }
}
