//
//  OnForegroundModifier.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-07-18.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

private struct OnForegroundModifier: ViewModifier {
    let action: (() async -> Void)
    @Environment(\.scenePhase) private var scenePhase
    @State private var isBackground = false

    func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { scenePhase in
                switch scenePhase {
                case .background:
                    isBackground = true
                case .active:
                    guard isBackground else { return }
                    isBackground = false
                    async { await action() }
                case .inactive:
                    break
                @unknown default:
                    break
                }
            }
    }
}

public extension View {
    /// Adds an action to perform when the current phase of the scene comes to the foreground.
    ///
    /// - Parameter action: The action to perform. If action is nil, the call has no effect.
    /// - Returns: A view that triggers action when this view has loaded.
    func onForeground(perform action: @escaping () async -> Void) -> some View {
        modifier(OnForegroundModifier(action: action))
    }
}
