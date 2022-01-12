//
//  Localizable.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-10-29.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

// MARK: - Extensions

public extension Label where Title == Text, Icon == Image {
    /// Creates a label with an icon image and a text view.
    ///
    /// - Parameters:
    ///    - text: A text view.
    ///    - image: The name of the image resource to lookup.
    init(_ title: Text, image name: String) {
        self.init(title, icon: Image(name))
    }

    /// Creates a label with a system icon image and a text view.
    ///
    /// - Parameters:
    ///    - text: A text view.
    ///    - systemImage: The name of the image resource to lookup.
    init(_ title: Text, systemImage name: String) {
        self.init(title, icon: Image(systemName: name))
    }

    /// Creates a label with an icon image and a text view.
    ///
    /// - Parameters:
    ///    - text: A text view.
    ///    - icon: The image resource.
    init(_ title: Text, icon: Image) {
        self = Label(
            title: { title },
            icon: { icon }
        )
    }
}

public extension Button where Label == Text {
    /// Creates a button that generates its label from a text view.
    ///
    /// - Parameters:
    ///   - text: A text view.
    ///   - action: The action to perform when the user triggers the button.
    init(_ title: Text, action: @escaping () -> Void) {
        self.init(action: action, label: { title })
    }
}

public extension TextField where Label == Text {
    /// Creates a text field with a prompt generated from a `Text`.
    ///
    /// You can associate an action to be invoked upon submission of this
    /// text field by using an `View.onSubmit(of:_)` modifier.
    ///
    /// - Parameters:
    ///   - label: A text view that describes the purpose of the text field.
    ///   - text: The text to display and edit.
    ///   - prompt: A `Text` representing the prompt of the text field
    ///     which provides users with guidance on what to type into the text field.
    init(_ label: Text, text: Binding<String>, prompt: Text? = nil) {
        self.init(text: text, prompt: prompt, label: { label })
    }
}
