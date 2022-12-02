//
//  ImageStyle.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-03-24.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

public protocol ImageStyle: ViewModifier {}

public extension View {
    /// Sets the style for images within this view.
    ///
    /// Use this modifier to set a specific style for all images within a view:
    ///
    ///     VStack {
    ///         Image(systemName: "alarm")
    ///         Image(systemName: "calendar")
    ///     }
    ///     .imageStyle(MyCustomImageStyle())
    ///
    func imageStyle(_ modifier: some ImageStyle) -> some View {
        self.modifier(modifier)
    }
}
