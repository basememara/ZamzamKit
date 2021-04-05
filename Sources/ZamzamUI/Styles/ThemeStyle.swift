//
//  ThemeStyle.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-02-23.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

public protocol ThemeStyle: ViewModifier {}

public extension View {
    func themeStyle<T: ThemeStyle>(_ modifier: T) -> some View {
        self.modifier(modifier)
    }
}
