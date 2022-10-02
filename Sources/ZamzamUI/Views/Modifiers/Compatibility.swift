//
//  Compatibility.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-02-08.
//  https://davedelong.com/blog/2021/10/09/simplifying-backwards-compatibility-in-swift/
//
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

/// Namespace for deprecated SwiftUI modifiers for backwards-compatibility purposes.
public struct Compatibility<Content> {
    public let content: Content

    public init(_ content: Content) {
        self.content = content
    }
}

public extension View {
    @available(iOS, deprecated: 16)
    @available(macOS, deprecated: 13)
    @available(tvOS, deprecated: 16)
    @available(watchOS, deprecated: 9)
    /// Namespace for new and deprecated SwiftUI modifiers for backwards-compatibility purposes.
    var compatibility: Compatibility<Self> { Compatibility(self) }
}

// MARK: - Extensions

#if !os(macOS) && !os(watchOS)
public extension Compatibility where Content: View {
    /// Sets the visibility of the status bar.
    func tabBarHidden(_ hidden: Bool = true) -> some View {
        content.modifier {
            if #available(iOS 16, tvOS 16, *) {
                $0.toolbar(hidden ? .hidden : .automatic, for: .tabBar)
            } else {
                $0
            }
        }
    }
}
#endif

#if !os(macOS)
public extension Compatibility where Content: View {
    /// Configures the behavior in which scrollable content interacts with the software keyboard.
    ///
    /// Enable people to interactively dismiss the keyboard as part of the scroll operation.
    func scrollDismissesKeyboard() -> some View {
        content.modifier {
            if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, *) {
                $0.scrollDismissesKeyboard(.interactively)
            } else {
                $0
            }
        }
    }
}
#endif

// MARK: - Navigation

public extension Compatibility where Content: View {
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
    ///             .compatibility.navigationDestination(isActive: $isLinkActive, destination: makeDestination())
    ///         }
    ///     }
    ///
    /// Use `NavigationStack` in favor of backport when `iOS 16, macOS 13, watchOS 9, tvOS 16` minimum version can be set.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the navigation should be shown.
    ///   - destination: A closure returning the content to navigate to.
    func navigationDestination<Destination>(
        isPresented: Binding<Bool>,
        destination: Destination?
    ) -> some View where Destination: View {
        content.background(
            NavigationLink(
                destination: destination,
                isActive: isPresented,
                label: EmptyView.init
            )
            .hidden()
        )
    }

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
    ///             .compatibility.navigationDestination(for: $date, destination: makeDestination)
    ///         }
    ///
    ///         func makeDestination(for date: Date) -> some View {
    ///             ...
    ///         }
    ///     }
    ///
    /// Use `NavigationStack` in favor of backport when `iOS 16, macOS 13, watchOS 9, tvOS 16` minimum version can be set.
    ///
    /// - Parameters:
    ///   - data: A binding to an optional source of truth for the navigation.
    ///   - destination: A closure returning the content to navigate to.
    func navigationDestination<Data: Identifiable, Destination: View>(
        for data: Binding<Data?>,
        @ViewBuilder destination: @escaping (Data) -> Destination
    ) -> some View {
        // https://swiftwithmajid.com/2021/01/27/lazy-navigation-in-swiftui/
        navigationDestination(
            isPresented: Binding(
                get: { data.wrappedValue != nil },
                set: { if !$0 { data.wrappedValue = nil } }
            ),
            destination: Group {
                if let item = data.wrappedValue {
                    destination(item)
                }
            }
        )
    }
}
