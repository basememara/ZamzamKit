//
//  WKPickerItem.swift
//  ZamzamKit watchOS
//
//  Created by Basem Emara on 2019-07-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import WatchKit
import ZamzamCore

public extension WKPickerItem {
    
    /// An initializer for a single item in a picker interface.
    ///
    /// - Parameters:
    ///   - title: The text to display for the item.
    ///   - caption: A caption for the item’s content.
    convenience init(title: String, caption: String? = nil) {
        self.init()
        
        self.title = title
        self.caption ?= caption
    }
}
