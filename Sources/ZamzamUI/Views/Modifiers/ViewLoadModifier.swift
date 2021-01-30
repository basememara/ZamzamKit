//
//  SwiftUIView.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-01-30.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

@available(iOS 13, *)
private struct ViewLoadModifier: ViewModifier {
    let action: (() -> Void)
    @State private var loaded = false
    
    func body(content: Content) -> some View {
        content.onAppear {
            guard !loaded else { return }
            loaded = true
            action()
        }
    }
}

@available(iOS 13, *)
public extension View {
    
    /// Adds an action to perform when this view has loaded.
    ///
    /// - Parameter action: The action to perform. If action is nil, the call has no effect.
    /// - Returns: A view that triggers action when this view has loaded.
    func onLoad(perform action: @escaping () -> Void) -> some View {
        modifier(ViewLoadModifier(action: action))
    }
}
