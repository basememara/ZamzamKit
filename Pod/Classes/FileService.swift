//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public class FileService: NSObject {
    
    public func fileInDocumentsDirectory(fileName: String) -> String {
        return (ZamzamConstants.Path.DOCUMENTS as NSString).stringByAppendingPathComponent(fileName)
    }
    
}
