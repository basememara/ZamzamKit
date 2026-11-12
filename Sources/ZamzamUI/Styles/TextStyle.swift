//
//  TextStyle.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-02-23.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

/// A view modifier that styles text, applied with `textStyle(_:)`.
public protocol TextStyle: ViewModifier {}

public extension View {
    /// Applies a text style to this view.
    ///
    ///     Text("Fire")
    ///         .textStyle(MyCustomTextStyle())
    ///
    /// The style is a modifier on this view, not an environment value. Views inside change only as far as the style's
    /// own modifiers reach them, as `font(_:)` does.
    func textStyle(_ modifier: some TextStyle) -> some View {
        self.modifier(modifier)
    }
}
