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
     
     - returns: File path from document directory
     */
    func path(of fileName: String, from directory: FileManager.SearchPathDirectory = .documentDirectory) -> String {
        let root = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first!
        return URL(fileURLWithPath: root).appendingPathComponent(fileName).path
    }
    
    /**
     Get file system paths for document file
     
     - parameter filter: Specify filter to apply
     
     - returns: List of file paths from document directory
     */
    func paths(from directory: FileManager.SearchPathDirectory = .documentDirectory, filter: ((URL) -> Bool)? = nil) -> [String] {
        let root = FileManager.default.urls(for: directory, in: .userDomainMask).first!
        
        // Get the directory contents including folders
        guard var directoryUrls = try? contentsOfDirectory(
            at: root,
            includingPropertiesForKeys: nil)
            else { return [String]() }
        
        // Filter the directory contents if applicable
        if let filter = filter {
            directoryUrls = directoryUrls.filter(filter)
        }
        
        return directoryUrls.map { $0.path }
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
            var location: URL?
            let response = $0.1
            let error = $0.2
            
            defer { complete(location, response, error) }
            guard error == nil, let source = $0.0 else { return }
            
            // Construct file destination
            let folder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let destination = folder.appendingPathComponent(nsURL.lastPathComponent)
            _ = try? FileManager.default.removeItem(at: destination)
            
            // Store remote file locally
            guard let _ = try? FileManager.default.moveItem(at: source, to: destination) else { return }
            
            location = destination
        }.resume()
    }
}
