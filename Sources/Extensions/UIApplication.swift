//
//  UIApplication.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import UIKit

public extension UIApplication {
    
    /**
     Update existing home short cut.

     - parameter type:    Indentifier of shortcut item.
     - parameter handler: Handler which to modify the shortcut item.
     */
    func updateShortcutItem(_ type: String, handler: (UIMutableApplicationShortcutItem) -> UIMutableApplicationShortcutItem) {
        guard let index = shortcutItems?.index(where: { $0.type == type }),
            let item = shortcutItems?[index].mutableCopy() as? UIMutableApplicationShortcutItem else {
                return
        }
        
        shortcutItems?[index] = handler(item)
    }
}


