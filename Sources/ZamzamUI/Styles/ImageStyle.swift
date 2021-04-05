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
    func imageStyle<T: ImageStyle>(_ modifier: T) -> some View {
        self.modifier(modifier)
    }
}
