//
//  HiddenModifier.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-02-15.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

/// A modifier that hides a view if the condition is met, otherwise it the view is shown.
@available(OSX 11, iOS 14, tvOS 14, watchOS 7, *)
private struct HiddenModifier: ViewModifier {
    let condition: Bool

    func body(content: Content) -> some View {
        content.modifier(if: condition) { content in
            content.hidden()
        } else: { content in
            content
        }
    }
}

@available(OSX 11, iOS 14, tvOS 14, watchOS 7, *)
public extension View {
    /// Hides this view conditionally.
    ///
    /// - Parameter condition: The condition to determine if the content should be applied.
    /// - Returns: The modified view.
    func hidden(_ condition: Bool) -> some View {
        modifier(HiddenModifier(condition: condition))
    }
}
