//
//  TextStyle.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-02-23.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

public protocol TextStyle: ViewModifier {}

public extension View {
    /// Sets the style for text views within this view.
    ///
    /// Use this modifier to set a specific style for all text views within a view:
    ///
    ///     VStack {
    ///         Text("Fire")
    ///         Text("Lightning")
    ///     }
    ///     .textStyle(MyCustomTextStyle())
    ///
    func textStyle<T: TextStyle>(_ modifier: T) -> some View {
        self.modifier(modifier)
    }
}
