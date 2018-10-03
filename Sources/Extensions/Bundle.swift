//
//  NSBundle.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/4/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Bundle {
    private class TempClassForBundle {}
    
    /// A representation of the code and resources stored in ZamzamKit bundle directory on disk.
    static var zamzamKit: Bundle {
        return Bundle(for: TempClassForBundle.self)
    }
}

public extension Bundle {
    
    /**
     Gets the contents of the specified file.
     
     - parameter file: Name of file to retrieve contents from.
     - parameter bundle: Bundle where defaults reside.
     - parameter encoding: Encoding of string from file.
     
     - returns: Contents of file.
     */
    func string(file: String, inDirectory: String? = nil, encoding: String.Encoding = .utf8) -> String? {
        guard let resourcePath = path(forResource: file, ofType: nil, inDirectory: inDirectory) else { return nil }
        return try? String(contentsOfFile: resourcePath, encoding: encoding)
    }
    
    /**
     Gets the contents of the specified plist file.
     
     - parameter plist: property list where defaults are declared
     - parameter bundle: bundle where defaults reside
     
     - returns: dictionary of values
     */
    func contents(plist: String, inDirectory: String? = nil) -> [String: Any] {
        guard let resourcePath = path(forResource: plist, ofType: nil, inDirectory: inDirectory),
            let contents = NSDictionary(contentsOfFile: resourcePath) as? [String: Any]
            else { return [:] }
        
        return contents
    }
}
