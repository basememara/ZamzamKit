//
//  CardStyle.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-03-06.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

/// A view modifier that styles a card, applied with `cardStyle(_:)`.
public protocol CardStyle: ViewModifier {}

public extension View {
    /// Applies a card style to this view.
    ///
    ///     VStack {
    ///         Text("Fire")
    ///         Text("Lightning")
    ///     }
    ///     .cardStyle(MyCustomCardStyle())
    ///
    ///     struct MyCustomCardStyle: CardStyle {
    ///         func body(content: Content) -> some View {
    ///             content
    ///                 .frame(maxWidth: .infinity)
    ///                 .padding()
    ///                 .background(Color(.systemBackground))
    ///                 .cornerRadius(6)
    ///         }
    ///     }
    ///
    func cardStyle(_ modifier: some CardStyle) -> some View {
        self.modifier(modifier)
    }
}
