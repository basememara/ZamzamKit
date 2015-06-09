//
//  Constants.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/12/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public struct ZamzamConstants {
    
    public struct Configuration {
        static let ROOT_KEY = "ZamzamKit configurations"
    }
    
    public struct Path {
        static let DOCUMENTS = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
        static let TMP = NSTemporaryDirectory()
    }
    
    public struct Location {
        static let DEG_TO_RAD = 0.017453292519943295769236907684886
        static let EARTH_RADIUS_IN_METERS = 6372797.560856
    }
    
    public struct Color {
        static func lightOrange() -> UIColor {
            return UIColor(red: 255/255, green: 211/255, blue: 127/255, alpha: 1)
        }
    }
    
}