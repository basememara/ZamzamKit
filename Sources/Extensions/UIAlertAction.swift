//
//  UIAlertAction.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/25/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension UIAlertAction {
    
    public convenience init(title: String, handler: (() -> Void)) {
        self.init(title: title, style: .Default) { _ in
            handler()
        }
    }
    
}