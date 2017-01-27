//
//  NSDateFormatter.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension DateFormatter {
    
    convenience init(dateFormat: String) {
        self.init()
        
        self.dateFormat = dateFormat
    }
    
}
