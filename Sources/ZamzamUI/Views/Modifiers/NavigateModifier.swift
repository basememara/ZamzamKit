//
//  NavigateModifier.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-02-08.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
private struct NavigateModifier<Destination: View>: ViewModifier {
    @Binding private(set) var isActive: Bool
    let destination: Destination?

    func body(content: Content) -> some View {
        content
            .background(
                NavigationLink(
                    destination: destination,
                    isActive: $isActive,
                    label: EmptyView.init
                )
                .hidden()
            )
    }
}

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension View {

    /// Navigates the user to the given destination using the provided binding value.
    ///
    ///     struct ShowMoreView: View {
    ///         @State private var isLinkActive = false
    ///
    ///         var body: some View {
    ///             List {
    ///                 Button(action: { isLinkActive = true })
    ///                     Text("Start navigation")
    ///                 }
    ///             }
    ///             .navigate(using: $isLinkActive, destination: makeDestination())
    ///         }
    ///     }
    ///
    func navigate<Destination: View>(
        using isActive: Binding<Bool>,
        destination: Destination?
    ) -> some View {
        modifier(NavigateModifier(isActive: isActive, destination: destination))
    }
}
