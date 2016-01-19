//
//  Constants.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/12/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public struct ZamzamConstants {
    
    public struct DateTime {
        public static let JSON_FORMAT = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    public struct Configuration {
        public static let FILE_NAME = "Zamzam-Info"
    }
    
    public struct Path {
        public static let DOCUMENTS = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        public static let TMP = NSTemporaryDirectory()
    }
    
    public struct Location {
        public static let DEG_TO_RAD = 0.017453292519943295769236907684886
        public static let EARTH_RADIUS_IN_METERS = 6372797.560856
    }
    
    public struct Notification {
        public static let MAIN_CATEGORY = "mainCategory"
        public static let IDENTIFIER_KEY = "identifier"
    }
    
    public struct Color {
        
    }
    
}

public extension ZamzamConstants.Color {
    
    public static func lightOrange() -> UIColor {
        return UIColor(red: 255/255, green: 211/255, blue: 127/255, alpha: 1)
    }
}