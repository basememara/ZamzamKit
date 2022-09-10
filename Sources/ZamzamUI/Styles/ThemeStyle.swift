//
//  ThemeStyle.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-02-23.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

public protocol ThemeStyle: ViewModifier {}

public extension View {
    /// Sets the theme for views within an app.
    ///
    /// Use this modifier to set a global them used within an app:
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
    ///                 .navigationViewStyle(.stack)
    ///                 .accentColor(.indigo)
    ///         }
    ///     }
    ///
    func themeStyle<T: ThemeStyle>(_ modifier: T) -> some View {
        self.modifier(modifier)
    }
}
