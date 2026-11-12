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
    /// Creates a label from a text view and the name of an image in the main bundle.
    init(_ title: Text, image name: String) {
        self.init(title, icon: Image(name))
    }

    /// Creates a label from a text view and the name of a system symbol.
    init(_ title: Text, systemImage name: String) {
        self.init(title, icon: Image(systemName: name))
    }

    /// Creates a label from a text view and an image.
    init(_ title: Text, icon: Image) {
        self = Label(
            title: { title },
            icon: { icon }
        )
    }
}

public extension Button where Label == Text {
    /// Creates a button whose label is a text view.
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
