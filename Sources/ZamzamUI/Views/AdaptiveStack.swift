//
//  AdaptiveStack.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2022-03-07.
//  Copyright © 2022 Zamzam Inc. All rights reserved.
//

import SwiftUI

/// A view that arranges its children in a horizontal line, or a vertical line at accessibility text sizes.
public struct AdaptiveStack<Content: View>: View {
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let spacing: CGFloat?
    let content: () -> Content
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

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
        // One layout that changes axis, so the children keep their identity when the text size crosses over
        let layout = dynamicTypeSize > .xLarge
            ? AnyLayout(VStackLayout(alignment: horizontalAlignment, spacing: spacing))
            : AnyLayout(HStackLayout(alignment: verticalAlignment, spacing: spacing))

        layout(content)
    }
}

// MARK: - Previews

#Preview(traits: .sizeThatFitsLayout) {
    AdaptiveStack {
        Text(verbatim: "Abc")
        Text(verbatim: "Xyz")
    }
}

#Preview("Accessibility", traits: .sizeThatFitsLayout) {
    AdaptiveStack {
        Text(verbatim: "Abc")
        Text(verbatim: "Xyz")
    }
    .dynamicTypeSize(.accessibility3)
}
