//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation
import Timepiece

public class ConfigurationService: NSObject {
    
    /**
    Reads value from plist file
    
    :param: key      key of value
    :param: rootKey  root node to read values from
    :param: fileName file name of plist
    
    :returns: value of key
    */
    public func getValue(key: String,
        rootKey: String = ZamzamConstants.Configuration.ROOT_KEY,
        fileName: String = ZamzamConstants.Configuration.FILE_NAME) -> String {
            // Read file and extract key/value
            if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist"),
                let type = NSDictionary(contentsOfFile: path),
                let config = type.objectForKey(rootKey) as? NSDictionary {
                    return config.objectForKey(key) as? String ?? ""
            }
            
            return ""
    }
    
    /**
    Reads integer from plist file
    
    :param: key      key of value
    :param: rootKey  root node to read values from
    :param: fileName file name of plist
    
    :returns: value of key
    */
    public func getIntValue(key: String,
        rootKey: String = ZamzamConstants.Configuration.ROOT_KEY,
        fileName: String = ZamzamConstants.Configuration.FILE_NAME) -> Int {
            if let value = getValue(key, rootKey: rootKey, fileName: fileName).toInt() {
                return value
            }
            
            return 0
    }
    
    /**
    Reads number from plist file
    
    :param: key      key of value
    :param: rootKey  root node to read values from
    :param: fileName file name of plist
    
    :returns: value of key
    */
    public func getDoubleValue(key: String,
        rootKey: String = ZamzamConstants.Configuration.ROOT_KEY,
        fileName: String = ZamzamConstants.Configuration.FILE_NAME) -> Double {
            let value = getValue(key, rootKey: rootKey, fileName: fileName)
            return NSString(string: value).doubleValue
    }
    
    /**
    Reads boolean from plist file
    
    :param: key      key of value
    :param: rootKey  root node to read values from
    :param: fileName file name of plist
    
    :returns: value of key
    */
    public func getBoolValue(key: String,
        rootKey: String = ZamzamConstants.Configuration.ROOT_KEY,
        fileName: String = ZamzamConstants.Configuration.FILE_NAME) -> Bool {
            let value = getValue(key, rootKey: rootKey, fileName: fileName)
            switch value.lowercaseString {
            case "true", "yes", "1":
                return true
            case "false", "no", "0":
                return false
            default:
                return false
            }
    }
    
    /**
    Reads date from plist file
    
    :param: key      key of value
    :param: rootKey  root node to read values from
    :param: fileName file name of plist
    
    :returns: value of key
    */
    public func getDateValue(key: String,
        format: String = "yyyy-MM-dd",
        rootKey: String = ZamzamConstants.Configuration.ROOT_KEY,
        fileName: String = ZamzamConstants.Configuration.FILE_NAME) -> NSDate? {
            let value = getValue(key, rootKey: rootKey, fileName: fileName)
            return value.dateFromFormat(format)
    }
    
}
