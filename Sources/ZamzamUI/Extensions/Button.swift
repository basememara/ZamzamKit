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
