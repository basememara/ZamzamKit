//
//  Button.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2022-01-12.
//  Copyright © 2022 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension Button where Label: View {
    /// Creates a button with a custom label that runs an async action on the main actor.
    ///
    /// Every tap starts a task of its own, and no task is cancelled when the button goes away.
    init(action: @escaping @MainActor () async -> Void, @ViewBuilder label: () -> Label) {
        self.init(action: { Task { await action() } }, label: label)
    }
}

public extension Button where Label == Text {
    /// Creates a button with a text label that runs an async action on the main actor, in a new task for every tap.
    init(_ title: Text, action: @escaping @MainActor () async -> Void) {
        self.init(action: action, label: { title })
    }
}

public extension Button {
    /// Creates a button with a role and a custom label that runs an async action on the main actor, in a new task for every tap.
    init(role: ButtonRole?, action: @escaping @MainActor () async -> Void, @ViewBuilder label: () -> Label) {
        self.init(role: role, action: { Task { await action() } }, label: label)
    }
}
