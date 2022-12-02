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
    ///     Circle().fill(Color.red, stroke: Color.purple, lineWidth: 5)
    ///
    /// - Parameters:
    ///   - fill: The color or gradient to use when filling this shape.
    ///   - stroke: The color or gradient with which to stroke this shape.
    ///   - lineWidth: The width of the stroke that outlines this shape.
    func fill(_ fillContent: some ShapeStyle, stroke strokeContent: some ShapeStyle, lineWidth: Double = 1) -> some View {
        // https://www.hackingwithswift.com/quick-start/swiftui/how-to-fill-and-stroke-shapes-at-the-same-time
        stroke(strokeContent, lineWidth: lineWidth).background(fill(fillContent))
    }
}
