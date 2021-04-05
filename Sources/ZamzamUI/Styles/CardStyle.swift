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
    func cardStyle<T: CardStyle>(_ modifier: T) -> some View {
        self.modifier(modifier)
    }
}
