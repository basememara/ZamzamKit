//
//  Image.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-01-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

#if os(macOS)
import AppKit.NSImage
public typealias PlatformImage = NSImage
#elseif canImport(UIKit)
import UIKit.UIImage
public typealias PlatformImage = UIImage
#endif

#if canImport(SwiftUI)
import SwiftUI

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension Image {
    
    init(platformImage image: PlatformImage) {
        #if os(macOS)
        self.init(nsImage: image)
        #elseif canImport(UIKit)
        self.init(uiImage: image)
        #endif
    }
}
#endif
