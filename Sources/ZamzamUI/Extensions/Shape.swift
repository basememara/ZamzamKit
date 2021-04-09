//
//  Shape.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-04-08.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension Shape {
    /// Fills and traces the outline of this shape with a color.
    ///
    /// The following example draws a circle filled with a red color with a purple stroke:
    ///
    ///     Circle().fill(.red, stroke: .purple, lineWidth: 5)
    ///
    /// - Parameters:
    ///   - fillColor: The color with which to fill this shape.
    ///   - strokeColor: The color with which to stroke this shape.
    ///   - lineWidth: The width of the stroke that outlines this shape.
    func fill(_ fillColor: Color, stroke strokeColor: Color, lineWidth: CGFloat = 1) -> some View {
        // https://stackoverflow.com/a/60425421
        ZStack {
            fill(fillColor)
            stroke(strokeColor, lineWidth: lineWidth)
        }
    }
}
