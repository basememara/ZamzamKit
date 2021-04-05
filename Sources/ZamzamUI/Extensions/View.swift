//
//  View.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-01-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension View {
    /// Returns a type-erased view.
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
