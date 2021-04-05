//
//  Font.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-03-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension View {
    /// Create a custom font with the given name and size that scales relative to the given `textStyle` and sets the line height.
    func font(
        _ name: String,
        size: CGFloat,
        relativeTo textStyle: Font.TextStyle,
        lineHeight: CGFloat,
        isMonospacedDigit: Bool = false
    ) -> some View {
        var custom: Font = .custom(name, size: size, relativeTo: textStyle)

        if isMonospacedDigit {
            custom = custom.monospacedDigit()
        }

        return self
            .font(custom)
            .modifier(if: lineHeight > size) { content in
                // https://stackoverflow.com/q/61705184
                content.lineSpacing((lineHeight - size) / 2)
            }
    }
}
