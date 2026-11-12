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
        content
            .overlay(
                Group {
                    if condition {
                        if let tint {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: tint))
                        } else {
                            ProgressView()
                        }
                    }
                }
            )
    }
}

public extension View {
    /// Shows a progress view over this view while the condition holds.
    ///
    ///     someView
    ///         .progress(if: model == nil)
    ///
    /// - Parameter tint: The progress view's color. `nil` keeps the default.
    func progress(if condition: Bool = true, tint: Color? = nil) -> some View {
        modifier(ConditionalProgress(condition: condition, tint: tint))
    }
}
