//
//  AppRoutable+watchOS.swift
//  ZamzamKit watchOS
//
//  Created by Basem Emara on 2019-07-19.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

#if os(watchOS)
import WatchKit

public extension AppRoutable {
    
    /// Dismisses the current interface controller from the screen.
    func dismiss() {
        viewController?.dismiss()
    }
}
#endif
