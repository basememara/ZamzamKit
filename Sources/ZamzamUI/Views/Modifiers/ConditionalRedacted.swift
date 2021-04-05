//
//  ConditionalRedacted.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2020-09-20.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftUI

/// A modifier that adds a redaction to this view hierarchy if the condition is met, otherwise it is `unredacted`.
private struct ConditionalRedacted: ViewModifier {
    let condition: Bool

    func body(content: Content) -> some View {
        content.modifier(if: condition) {
            $0.redacted(reason: .placeholder)
        } else: {
            $0.unredacted()
        }
    }
}

public extension View {
    /// Adds a redaction to this view hierarchy if the condition is met, otherwise it is `unredacted`.
    ///
    /// - Parameter condition: The condition to determine if the content should be applied.
    /// - Returns: The modified view.
    func redacted(if condition: Bool) -> some View {
        modifier(ConditionalRedacted(condition: condition))
    }
}
