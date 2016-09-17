//
//  NSFileManagerExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension NSFileManager {
    
    /**
     Get file system path for document file
     
     - parameter fileName: Name of file
     
     - returns: File path from document directory
     */
    public static func getDocumentPath(fileName: String) -> String {
        return NSURL(fileURLWithPath: ZamzamConstants.Path.DOCUMENTS)
            .URLByAppendingPathComponent(fileName)!
            .path!
    }
    
    /**
     Get file system paths for document file
     
     - parameter filter: Specify filter to apply
     
     - returns: List of file paths from document directory
     */
    public static func getDocumentPaths(filter: ((NSURL) -> Bool)? = nil) -> [String] {
        // Get the directory contents including folders
        guard var directoryUrls = try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(
            ZamzamConstants.Path.DOCUMENTS_URL,
            includingPropertiesForKeys: nil,
            options: NSDirectoryEnumerationOptions()) else {
                // Failed so return empty list
                return [String]()
        }
        
        // Filter the directory contents if applicable
        if let f = filter {
            directoryUrls = directoryUrls.filter(f)
        }
        
        return directoryUrls.map { $0.path! }
    }
    
}
