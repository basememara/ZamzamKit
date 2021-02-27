//
//  View.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-01-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension View {

    /// Returns a type-erased view.
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
#endif
