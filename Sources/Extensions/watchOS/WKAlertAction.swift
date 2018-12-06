//
//  WKAlertAction.swift
//  ZamzamKit watchOS
//
//  Created by Basem Emara on 2018-12-06.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import WatchKit

public extension WKAlertAction {
    
    convenience init(title: String, handler: @escaping (() -> Void)) {
        self.init(title: title, style: .default) { 
            handler()
        }
    }
}
