//
//  ViewLoadModifier.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-07-18.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

private struct ViewLoadModifier: ViewModifier {
    let action: (() async -> Void)
    @State private var loaded = false

    func body(content: Content) -> some View {
        // https://stackoverflow.com/a/64495887
        content.task {
            guard !loaded else { return }
            loaded = true
            await action()
        }
    }
}

public extension View {
    /// Adds an action to perform when this view has loaded.
    ///
    ///     struct ContentView: View {
    ///         @StateObject var model = ContentModel()
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Text(model.title)
    ///             }
    ///             .onLoad {
    ///                 await model.fetch()
    ///             }
    ///         }
    ///     }
    ///
    /// The `onLoad` modifier only executes the first time only, even on subsequent view redraws.
    /// This modifier is alternative to the `onAppear` and `task` that execute on every appearance.
    ///
    /// - Parameter action: The async action to perform.
    /// - Returns: A view that triggers action when this view has loaded.
    func onLoad(perform action: @escaping () async -> Void) -> some View {
        modifier(ViewLoadModifier(action: action))
    }
}
