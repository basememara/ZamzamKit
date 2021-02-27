//
//  ConditionalModifier.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2020-09-20.
//  https://fivestars.blog/swiftui/conditional-modifiers.html
//  https://forums.swift.org/t/conditionally-apply-modifier-in-swiftui
//
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI

@available(OSX 11, iOS 14, tvOS 14, watchOS 7, *)
public extension View {

    /// Applies a modifier to a view conditionally.
    ///
    ///     someView
    ///         .modifier(if: model == nil) {
    ///             $0.redacted(reason: .placeholder )
    ///         }
    ///
    /// - Parameters:
    ///   - condition: The condition to determine if the content should be applied.
    ///   - content: The modifier to apply to the view.
    /// - Returns: The modified view.
    @ViewBuilder func modifier<T: View>(
        if condition: Bool,
        then content: (Self) -> T
    ) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }

    /// Applies a modifier to a view conditionally.
    ///
    ///     someView
    ///         .modifier(if: model == nil) {
    ///             $0.redacted(reason: .placeholder )
    ///         } else: {
    ///             $0.unredacted()
    ///         }
    ///
    /// - Parameters:
    ///   - condition: The condition to determine the content to be applied.
    ///   - trueContent: The modifier to apply to the view if the condition passes.
    ///   - falseContent: The modifier to apply to the view if the condition fails.
    /// - Returns: The modified view.
    @ViewBuilder func modifier<TrueContent: View, FalseContent: View>(
        if condition: Bool,
        then trueContent: (Self) -> TrueContent,
        else falseContent: (Self) -> FalseContent
    ) -> some View {
        if condition {
            trueContent(self)
        } else {
            falseContent(self)
        }
    }
}
#endif
