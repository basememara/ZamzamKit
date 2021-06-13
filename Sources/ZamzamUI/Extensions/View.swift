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

public extension View {
    /// Binds the height of the view to a property.
    func assign(heightTo height: Binding<CGFloat>) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear { height.wrappedValue = geometry.size.height }
            }
        )
    }
}

public extension View {
    /// Adds an action to perform when this view detects a notification emitted by the `NotificationCenter` publisher.
    /// 
    /// - Parameters:
    ///   - name: The name of the notification to publish.
    ///   - object: The object posting the named notification.
    ///   - action: The action to perform when the notification is emitted by publisher.
    /// - Returns: View
    func onNotification(
        for name: Notification.Name,
        object: AnyObject? = nil,
        perform action: @escaping (Notification) -> Void
    ) -> some View {
        // https://github.com/gtokman/ExtensionKit
        onReceive(NotificationCenter.default.publisher(for: name, object: object), perform: action)
    }

    /// Adds an action to perform when this view detects a notification emitted by the `NotificationCenter` publisher.
    ///
    /// - Parameters:
    ///   - name: The name of the notification to publish.
    ///   - object: The object posting the named notification.
    ///   - action: The action to perform when the notification is emitted by publisher.
    /// - Returns: View
    @available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
    func onNotification(
        for name: Notification.Name,
        object: AnyObject? = nil,
        perform action: @escaping (Notification) async -> Void
    ) -> some View {
        onReceive(NotificationCenter.default.publisher(for: name, object: object)) { notification in
            async { await action(notification) }
        }
    }
}

#if os(iOS)
struct RoundedRect: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        return Path(path.cgPath)
    }
}

public extension View {
    /// Clips this view to its bounding frame, with the specified corner radius.
    ///
    ///     Text("Rounded Corners")
    ///         .frame(width: 175, height: 75)
    ///         .foregroundColor(Color.white)
    ///         .background(Color.black)
    ///         .cornerRadius(25, corners: [.topLeft, .topRight])
    ///
    /// Creates and returns a new Bézier path object with a rectangular path rounded at the specified corners.
    /// For rounding all corners, use the native `.cornerRadius(_ radius:)` function.
    ///
    /// - Parameters:
    ///   - radius: The corner radius.
    ///   - corners: A bitmask value that identifies the corners that you want rounded.
    ///     You can use this parameter to round only a subset of the corners of the rectangle.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedRect(radius: radius, corners: corners))
    }
}
#endif
