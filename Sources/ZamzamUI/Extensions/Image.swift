//
//  Image.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-01-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI
#if os(macOS)
import AppKit.NSImage
public typealias PlatformImage = NSImage
#elseif canImport(UIKit)
import UIKit.UIImage
public typealias PlatformImage = UIImage
#endif

public extension Image {
    init(platformImage image: PlatformImage) {
        #if os(macOS)
        self.init(nsImage: image)
        #elseif canImport(UIKit)
        self.init(uiImage: image)
        #endif
    }
}
