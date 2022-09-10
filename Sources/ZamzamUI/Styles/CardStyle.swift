//
//  CardStyle.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-03-06.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

public protocol CardStyle: ViewModifier {}

public extension View {
    /// Sets the style for cards within this view.
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
    func cardStyle<T: CardStyle>(_ modifier: T) -> some View {
        self.modifier(modifier)
    }
}
