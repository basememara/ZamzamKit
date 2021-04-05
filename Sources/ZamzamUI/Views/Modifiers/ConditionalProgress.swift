//
//  ConditionalProgress.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2020-10-16.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftUI

/// A modifier that adds a progress view over this view if the condition is met, otherwise it no progress view is shown.
private struct ConditionalProgress: ViewModifier {
    let condition: Bool
    let tint: Color?

    func body(content: Content) -> some View {
        content.modifier(if: condition) { content in
            ZStack {
                content
                if let tint = tint {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: tint))
                } else {
                    ProgressView()
                }
            }
        } else: { content in
            content
        }
    }
}

public extension View {
    /// Adds a progress view over this view if the condition is met, otherwise it no progress view is shown.
    ///
    /// - Parameter condition: The condition to determine if the content should be applied.
    /// - Returns: The modified view.
    func progress(if condition: Bool = true, tint: Color? = nil) -> some View {
        modifier(ConditionalProgress(condition: condition, tint: tint))
    }
}
