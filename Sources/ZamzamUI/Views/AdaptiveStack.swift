//
//  AdaptiveStack.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2022-03-07.
//  Copyright © 2022 Zamzam Inc. All rights reserved.
//

import SwiftUI

/// A view that arranges its children in a horizontal line, or vertical line if the size category is one that is associated with accessibility.
public struct AdaptiveStack<Content: View>: View {
    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-automatically-switch-between-hstack-and-vstack-based-on-size-class
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let spacing: CGFloat?
    let content: () -> Content
    @Environment(\.sizeCategory) private var sizeCategory

    public init(
        horizontalAlignment: HorizontalAlignment = .center,
        verticalAlignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        if sizeCategory.isAccessibilityCategory {
            VStack(alignment: horizontalAlignment, spacing: spacing, content: content)
        } else {
            HStack(alignment: verticalAlignment, spacing: spacing, content: content)
        }
    }
}

// MARK: - Previews

struct AdaptiveStack_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AdaptiveStack {
                Text("Abc")
                Text("Xyx")
            }
            AdaptiveStack {
                Text("Abc")
                Text("Xyx")
            }
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            .previewDisplayName("Accessibility")
        }
        .frame(width: 300, height: 300)
        .previewLayout(.sizeThatFits)
    }
}
