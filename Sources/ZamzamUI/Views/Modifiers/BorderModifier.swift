//
//  BorderModifier.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-03-04.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

/// A modifier that draws a clipped, rounded border around a view.
private struct BorderModifier: ViewModifier {
    let color: Color
    let width: CGFloat
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius)

        return content
            .clipShape(shape)
            .overlay(shape.stroke(color, lineWidth: width))
    }
}

public extension View {
    /// Adds a border to this view with the specified color, width, and radius.
    func border(_ color: Color, width: CGFloat = 1, cornerRadius: CGFloat) -> some View {
        modifier(BorderModifier(color: color, width: width, cornerRadius: cornerRadius))
    }
}
