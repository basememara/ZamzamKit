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
    static func getDocumentPath(_ fileName: String) -> String {
        return URL(fileURLWithPath: ZamzamConstants.Path.DOCUMENTS)
            .appendingPathComponent(fileName)
            .path
    }
    
    /**
     Get file system paths for document file
     
     - parameter filter: Specify filter to apply
     
     - returns: List of file paths from document directory
     */
    static func getDocumentPaths(_ filter: ((URL) -> Bool)? = nil) -> [String] {
        // Get the directory contents including folders
        guard var directoryUrls = try? FileManager.default.contentsOfDirectory(
            at: ZamzamConstants.Path.DOCUMENTS_URL,
            includingPropertiesForKeys: nil)
                else { return [String]() }
        
        // Filter the directory contents if applicable
        if let filter = filter {
            directoryUrls = directoryUrls.filter(filter)
        }
        
        return directoryUrls.map { $0.path }
    }
    
}
