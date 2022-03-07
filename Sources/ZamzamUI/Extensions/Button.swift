//
//  Button.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2022-01-12.
//  Copyright © 2022 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension Button where Label: View {
    /// Creates a button that displays a custom label.
    ///
    /// - Parameters:
    ///   - action: The async action to perform when the user triggers the button.
    ///   - label: A view that describes the purpose of the button's `action`.
    init(action: @escaping () async -> Void, @ViewBuilder label: () -> Label) {
        self.init(action: { Task { await action() } }, label: label)
    }
}

public extension Button where Label == Text {
    /// Creates a button that generates its label from a text view.
    ///
    /// - Parameters:
    ///   - text: A text view.
    ///   - action: The action to perform when the user triggers the button.
    init(_ title: Text, action: @escaping () async -> Void) {
        self.init(action: action, label: { title })
    }
}

public extension Button {
    /// Creates a button with a specified role that displays a custom label.
    ///
    /// - Parameters:
    ///   - role: An optional semantic role that describes the button. A value of `nil` means that the button doesn't have an assigned role.
    ///   - action: The async action to perform when the user interacts with the button.
    ///   - label: A view that describes the purpose of the button's `action`.
    init(role: ButtonRole?, action: @escaping () async -> Void, @ViewBuilder label: () -> Label) {
        self.init(role: role, action: { Task { await action() } }, label: label)
    }
}
