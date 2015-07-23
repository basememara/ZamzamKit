//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation
import Timepiece

public class ZamzamConfig: NSObject {
    
    /**
    Get values from plist file
    
    :param: fileName file name of plist
    
    :returns: collection of values
    */
    public static func getFile(fileName: String = ZamzamConstants.Configuration.FILE_NAME) -> NSDictionary {
            // Read file and extract key/value
            if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist"),
                let file = NSDictionary(contentsOfFile: path) {
                    return file
            }
            
            return [:]
    }
    
    /**
    Get values from root node
    
    :param: rootKey  key of root node
    :param: fileName file name of plist
    
    :returns: collection of values
    */
    public static func getRootConfig(rootKey: String = ZamzamConstants.Configuration.ROOT_KEY,
        fileName: String = ZamzamConstants.Configuration.FILE_NAME) -> NSDictionary {
            let file = getFile(fileName: fileName)
            
            // Read file and extract key/value
            if let config = file.objectForKey(rootKey) as? NSDictionary {
                return config
            }
            
            return [:]
    }
    
    /**
    Reads value from plist file
    
    :param: key      key of value
    :param: rootKey  root node to read values from
    :param: fileName file name of plist
    
    :returns: value of key
    */
    public static func getValue(key: String,
        rootKey: String = ZamzamConstants.Configuration.ROOT_KEY,
        fileName: String = ZamzamConstants.Configuration.FILE_NAME) -> String {
            let config = getRootConfig(rootKey: rootKey, fileName: fileName)
            
            // Read file and extract key/value
            return config.objectForKey(key) as? String ?? ""
    }
    
    /**
    Reads integer from plist file
    
    :param: key      key of value
    :param: rootKey  root node to read values from
    :param: fileName file name of plist
    
    :returns: value of key
    */
    public static func getIntValue(key: String,
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
    public static func getDoubleValue(key: String,
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
    public static func getBoolValue(key: String,
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
    public static func getDateValue(key: String,
        format: String = "yyyy-MM-dd",
        rootKey: String = ZamzamConstants.Configuration.ROOT_KEY,
        fileName: String = ZamzamConstants.Configuration.FILE_NAME) -> NSDate? {
            let value = getValue(key, rootKey: rootKey, fileName: fileName)
            return value.dateFromFormat(format)
    }
    
    /**
    Reads array from plist file
    
    :param: key      key of value
    :param: rootKey  root node to read values from
    :param: fileName file name of plist
    
    :returns: value of key
    */
    public static func getArrayValue(key: String,
        rootKey: String = ZamzamConstants.Configuration.ROOT_KEY,
        fileName: String = ZamzamConstants.Configuration.FILE_NAME) -> [String] {
            let config = getRootConfig(rootKey: rootKey, fileName: fileName)
            return config.objectForKey(key) as? [String] ?? []
    }
    
    /**
    Reads dictionary from plist file
    
    :param: key      key of value
    :param: rootKey  root node to read values from
    :param: fileName file name of plist
    
    :returns: value of key
    */
    public static func getDictionaryValue(key: String,
        rootKey: String = ZamzamConstants.Configuration.ROOT_KEY,
        fileName: String = ZamzamConstants.Configuration.FILE_NAME) -> [String: String] {
            let config = getRootConfig(rootKey: rootKey, fileName: fileName)
            return config.objectForKey(key) as? [String: String] ?? [:]
    }
    
    /**
    Reads array of dictionary from plist file
    
    :param: key      key of value
    :param: rootKey  root node to read values from
    :param: fileName file name of plist
    
    :returns: value of key
    */
    public static func getArrayOfDictionary(key: String,
        rootKey: String = ZamzamConstants.Configuration.ROOT_KEY,
        fileName: String = ZamzamConstants.Configuration.FILE_NAME) -> [[String: String]] {
            let config = ZamzamConfig.getRootConfig(rootKey: rootKey, fileName: fileName)
            return config.objectForKey(key) as? [[String: String]] ?? [[:]]
    }
    
}
