//
//  UIAlertAction.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/25/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import UIKit

public extension UIAlertAction {
    
    convenience init(title: String, handler: @escaping (() -> Void)) {
        self.init(title: title, style: .default) { _ in
            handler()
        }
    }
}
