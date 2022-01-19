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

import SwiftUI

public extension View {
    /// Applies a modifier to a view conditionally.
    ///
    ///     someView
    ///         .modifier(if: model == nil) {
    ///             $0.redacted(reason: .placeholder )
    ///         }
    ///
    /// - Warning: The view will re-render when the condition is changed.
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
    /// - Warning: The view will re-render when the condition is changed.
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

public extension View {
    /// Applies a modifier to a view if an optional item can be unwrapped.
    ///
    ///     someView
    ///         .modifier(let: model) { (content, model) in
    ///             content.background(BackgroundView(model.bg))
    ///         }
    ///
    /// - Parameters:
    ///   - item: The optional item to determine if the content should be applied.
    ///   - content: The modifier and unwrapped item to apply to the view.
    /// - Returns: The modified view.
    @ViewBuilder func modifier<T: View, Item>(
        `let` item: Item?,
        then content: (Self, Item) -> T
    ) -> some View {
        if let item = item {
            content(self, item)
        } else {
            self
        }
    }

    /// Applies a modifier to a view if an optional item can be unwrapped.
    ///
    ///     someView
    ///         .modifier(let: model) { (content, model) in
    ///             content.background(BackgroundView(model.bg))
    ///         } else: {
    ///             $0.background(Color.black)
    ///         }
    ///
    /// - Parameters:
    ///   - item: The optional item to determine if the content should be applied.
    ///   - trueContent: The modifier and unwrapped item to apply to the view.
    ///   - falseContent: The modifier to apply to the view if the condition fails.
    /// - Returns: The modified view.
    @ViewBuilder func modifier<Item, TrueContent: View, FalseContent: View>(
        `let` item: Item?,
        then trueContent: (Self, Item) -> TrueContent,
        else falseContent: (Self) -> FalseContent
    ) -> some View {
        if let item = item {
            trueContent(self, item)
        } else {
            falseContent(self)
        }
    }
}
