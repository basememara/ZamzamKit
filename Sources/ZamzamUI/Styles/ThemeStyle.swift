//
//  ThemeStyle.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-02-23.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

/// A view modifier that sets an app's shared look, applied with `themeStyle(_:)`.
public protocol ThemeStyle: ViewModifier {}

public extension View {
    /// Applies a theme to this view, such as the root view of a scene.
    ///
    ///     struct MyScene: Scene {
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 ContentView()
    ///                     .themeStyle(MyDefaultTheme())
    ///             }
    ///         }
    ///     }
    ///
    ///     struct MyDefaultTheme: ThemeStyle {
    ///         func body(content: Content) -> some View {
    ///             content
    ///                 .accentColor(.indigo)
    ///         }
    ///     }
    ///
    func themeStyle(_ modifier: some ThemeStyle) -> some View {
        self.modifier(modifier)
    }
}
