//
//  ImageStyle.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-03-24.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

/// A view modifier that styles an image, applied with `imageStyle(_:)`.
public protocol ImageStyle: ViewModifier {}

public extension View {
    /// Applies an image style to this view.
    ///
    ///     Image(systemName: "alarm")
    ///         .imageStyle(MyCustomImageStyle())
    ///
    /// The style is a modifier on this view, not an environment value. Views inside change only as far as the style's
    /// own modifiers reach them, as `font(_:)` does.
    func imageStyle(_ modifier: some ImageStyle) -> some View {
        self.modifier(modifier)
    }
}
