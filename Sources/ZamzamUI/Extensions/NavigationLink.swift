//
//  NavigateModifier.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-02-08.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

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
    ///             .navigate(isActive: $isLinkActive, destination: makeDestination())
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - isActive: A binding to whether the navigation should be shown.
    ///   - destination: A closure returning the content to navigate to.
    func navigate<Destination: View>(
        isActive: Binding<Bool>,
        destination: Destination?
    ) -> some View {
        background(
            NavigationLink(
                destination: destination,
                isActive: isActive,
                label: EmptyView.init
            )
            .hidden()
        )
    }
}

public extension View {
    /// Navigates the user to the given destination using the provided binding value.
    ///
    ///     struct ShowMoreView: View {
    ///         @State private var date: Date?
    ///
    ///         var body: some View {
    ///             List {
    ///                 Button(action: { date = Date() })
    ///                     Text("Start navigation")
    ///                 }
    ///             }
    ///             .navigate(item: $date, destination: makeDestination)
    ///         }
    ///
    ///         func makeDestination(for date: Date) -> some View {
    ///             ...
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the navigation.
    ///   - destination: A closure returning the content to navigate to.
    func navigate<Item, Destination: View>(
        item: Binding<Item?>,
        destination: (Item) -> Destination
    ) -> some View {
        // https://swiftwithmajid.com/2021/01/27/lazy-navigation-in-swiftui/
        navigate(
            isActive: Binding(
                get: { item.wrappedValue != nil },
                set: { if !$0 { item.wrappedValue = nil } }
            ),
            destination: Group {
                if let item = item.wrappedValue {
                    destination(item)
                }
            }
        )
    }
}
