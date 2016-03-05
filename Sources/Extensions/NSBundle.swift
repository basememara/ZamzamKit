//
//  NSBundle.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/4/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension NSBundle {
    
    /**
     Gets the contents of the specified plist file.
     
     - parameter plistName: property list where defaults are declared
     - parameter bundle: bundle where defaults reside
     
     - returns: dictionary of values
     */
    public static func contentsOfFile(plistName: String, bundle: NSBundle? = nil) -> [String : AnyObject] {
        let fileParts = plistName.componentsSeparatedByString(".")
        
        guard fileParts.count == 2,
            let resourcePath = (bundle ?? NSBundle.mainBundle()).pathForResource(fileParts[0], ofType: fileParts[1]),
            let contents = NSDictionary(contentsOfFile: resourcePath) as? [String : AnyObject]
            else { return [:] }
        
        return contents
    }
    
    /**
     Gets the contents of the specified bundle URL.
     
     - parameter bundleURL: bundle URL where defaults reside
     - parameter plistName: property list where defaults are declared
     
     - returns: dictionary of values
     */
    public static func contentsOfFile(bundleURL bundleURL: NSURL, plistName: String = "Root.plist") -> [String : AnyObject] {
        // Extract plist file from bundle
        guard let contents = NSDictionary(contentsOfURL: bundleURL.URLByAppendingPathComponent(plistName))
            else { return [:] }
        
        // Collect default values
        guard let preferences = contents.valueForKey("PreferenceSpecifiers") as? [String: AnyObject]
            else { return [:] }
        
        return preferences
    }
    
    /**
     Gets the contents of the specified bundle name.
     
     - parameter bundleName: bundle name where defaults reside
     - parameter plistName: property list where defaults are declared
     
     - returns: dictionary of values
     */
    public static func contentsOfFile(bundleName bundleName: String, plistName: String = "Root.plist") -> [String : AnyObject] {
        guard let bundleURL = NSBundle.mainBundle().URLForResource(bundleName, withExtension: "bundle")
            else { return [:] }
        
        return contentsOfFile(bundleURL: bundleURL, plistName: plistName)
    }
    
    /**
     Gets the contents of the specified bundle.
     
     - parameter bundle: bundle where defaults reside
     - parameter bundleName: bundle name where defaults reside
     - parameter plistName: property list where defaults are declared
     
     - returns: dictionary of values
     */
    public static func contentsOfFile(bundle bundle: NSBundle, bundleName: String = "Settings", plistName: String = "Root.plist") -> [String : AnyObject] {
        guard let bundleURL = bundle.URLForResource(bundleName, withExtension: "bundle")
            else { return [:] }
        
        return contentsOfFile(bundleURL: bundleURL, plistName: plistName)
    }
    
}