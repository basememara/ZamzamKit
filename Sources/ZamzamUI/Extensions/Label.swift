//
//  Label.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-03-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension Label where Title == Text, Icon == Image {
    /// Creates a label with an icon image and a text view.
    ///
    /// - Parameters:
    ///    - text: A text view.
    ///    - image: The name of the image resource to lookup.
    init(_ title: Text, image name: String) {
        self = Label(
            title: { title },
            icon: { Image(name) }
        )
    }

    /// Creates a label with a system icon image and a text view.
    ///
    /// - Parameters:
    ///    - text: A text view.
    ///    - systemImage: The name of the image resource to lookup.
    init(_ title: Text, systemImage name: String) {
        self = Label(
            title: { title },
            icon: { Image(systemName: name) }
        )
    }
}

public extension Label where Title == Text, Icon == Image {
    /// Creates a label with a strongly-typed image and a title generated from a localized string.
    ///
    ///      extension Image.Name {
    ///          static let myImage1 = Self(value: "my-image-1")
    ///          static let myImage2 = Self(value: "my-image-2")
    ///      }
    ///
    ///      struct ExampleView: View {
    ///          var body: some View {
    ///              VStack {
    ///                  Label("label_1", image: .myImage1)
    ///                  Label("label_2", image: .myImage2)
    ///              }
    ///          }
    ///      }
    init(_ titleKey: LocalizedStringKey, image: Image.Name) {
        self.init(titleKey, image: image.value)
    }

    /// Creates a label with a strongly-typed image and a title generated from a localized string.
    ///
    ///      extension Image.Name {
    ///          static let myImage1 = Self(value: "my-image-1")
    ///          static let myImage2 = Self(value: "my-image-2")
    ///      }
    ///
    ///      struct ExampleView: View {
    ///          var body: some View {
    ///              VStack {
    ///                  Label("Name", image: .myImage1)
    ///                  Label("Email", image: .myImage2)
    ///              }
    ///          }
    ///      }
    init<S>(_ title: S, image: Image.Name) where S: StringProtocol {
        self.init(title, image: image.value)
    }
}
