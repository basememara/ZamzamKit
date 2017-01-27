//
//  UIAlertAction.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/25/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension UIAlertAction {
    
    convenience init(title: String, handler: @escaping (() -> Void)) {
        self.init(title: title, style: .default) { _ in
            handler()
        }
    }
    
}
