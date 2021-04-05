//
//  UIApplication.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIApplication {
    /// The app's key window that is also backwards compatiable.
    var currentWindow: UIWindow? {
        windows.first { $0.isKeyWindow }
    }
}

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

public extension UIApplication {
    /// The physical orientation of the device.
    struct Orientation {
        private let device: UIDevice
        private let application: UIApplication

        init(for application: UIApplication) {
            self.device = .current
            self.application = application
        }

        /// Returns a Boolean value indicating whether the device is in a portrait orientation.
        var isPortrait: Bool {
            return device.orientation.isValidInterfaceOrientation
                ? device.orientation.isPortrait
                : application.statusBarOrientation.isPortrait
        }

        /// Returns a Boolean value indicating whether the device is in a landscape orientation.
        var isLandscape: Bool {
            return device.orientation.isValidInterfaceOrientation
                ? device.orientation.isLandscape
                : application.statusBarOrientation.isLandscape
        }
    }

    /// Returns the physical orientation of the device.
    ///
    /// This property is safer than `UIDevice.current.orientation` since it falls back
    /// on `statusBarOrientation` if the device orientation is not valid yet.
    var orientation: Orientation {
        // https://stackoverflow.com/a/45705783
        .init(for: self)
    }
}
#endif
