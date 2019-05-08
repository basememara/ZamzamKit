//
//  UIApplication.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit

public extension UIApplication {
    
    /// Update existing home short cut.
    ///
    /// - Parameters:
    ///   - type: Indentifier of shortcut item.
    ///   - handler: Handler which to modify the shortcut item.
    func updateShortcutItem(_ type: String, handler: (UIMutableApplicationShortcutItem) -> UIMutableApplicationShortcutItem) {
        guard let index = shortcutItems?.firstIndex(where: { $0.type == type }),
            let item = shortcutItems?[index].mutableCopy() as? UIMutableApplicationShortcutItem else {
                return
        }
        
        shortcutItems?[index] = handler(item)
    }
}


