//
//  ConditionalProgress.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2020-10-16.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI

/// A modifier that adds a progress view over this view if the condition is met, otherwise it no progress view is shown.
@available(OSX 11, iOS 14, tvOS 14, watchOS 7, *)
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

@available(OSX 11, iOS 14, tvOS 14, watchOS 7, *)
public extension View {

    /// Adds a progress view over this view if the condition is met, otherwise it no progress view is shown.
    ///
    /// - Parameter condition: The condition to determine if the content should be applied.
    /// - Returns: The modified view.
    func progress(if condition: Bool, tint: Color? = nil) -> some View {
        modifier(ConditionalProgress(condition: condition, tint: tint))
    }
}
#endif
