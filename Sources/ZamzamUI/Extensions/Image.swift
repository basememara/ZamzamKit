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

public extension Image {
    struct Name {
        let value: String

        public init(value: String) {
            self.value = value
        }
    }

    /// Creates a labeled image from a strongly-typed value.
    ///
    ///      extension Image.Name {
    ///          static let myImage1 = Self(value: "my-image-1")
    ///          static let myImage2 = Self(value: "my-image-2")
    ///      }
    ///
    ///      struct ExampleView: View {
    ///          var body: some View {
    ///              VStack {
    ///                  Image(.myImage1)
    ///                  Image(.myImage2)
    ///              }
    ///          }
    ///      }
    init(_ name: Name, bundle: Bundle? = nil) {
        self.init(name.value, bundle: bundle)
    }

    /// Creates an unlabeled, decorative image from a strongly-typed value.
    ///
    ///      extension Image.Name {
    ///          static let myImage1 = Self(value: "my-image-1")
    ///          static let myImage2 = Self(value: "my-image-2")
    ///      }
    ///
    ///      struct ExampleView: View {
    ///          var body: some View {
    ///              VStack {
    ///                  Image(decorative: .myImage1)
    ///                  Image(decorative: .myImage2)
    ///              }
    ///          }
    ///      }
    init(decorative name: Name, bundle: Bundle? = nil) {
        self.init(decorative: name.value, bundle: bundle)
    }
}
