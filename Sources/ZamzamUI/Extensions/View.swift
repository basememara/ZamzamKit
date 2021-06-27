//
//  View.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-01-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Combine
import SwiftUI

public extension View {
    /// Returns a type-erased view.
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

public extension View {
    /// Hides this view conditionally.
    ///
    /// - Parameter condition: The condition to determine if the content should be applied.
    /// - Returns: The modified view.
    func hidden(_ condition: Bool) -> some View {
        modifier(if: condition) { content in
            content.hidden()
        } else: { content in
            content
        }
    }
}

// MARK: - Receive

public extension View {
    /// Adds a modifier for this view that fires an action when a specific value changes.
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - action: A concurrent closure to run when the value changes.
    ///   - newValue: The new value that failed the comparison check.
    /// - Returns: A view that fires an action when the specified value changes.
    func onChange<V>(
        of value: V,
        perform action: @escaping (_ newValue: V) async -> Void
    ) -> some View where V: Equatable {
        onChange(of: value) { newValue in async { await action(newValue) } }
    }
}

public extension View {
    /// Adds an action to perform when this view detects data emitted by the optional publisher.
    ///
    /// - Parameters:
    ///   - publisher: The publisher to subscribe to.
    ///   - action: The action to perform when an event is emitted by `publisher`.
    /// - Returns: A view that triggers action when publisher emits an event.
    func onReceive<P>(
        _ publisher: P?,
        perform action: @escaping (P.Output) -> Void
    ) -> some View where P: Publisher, P.Failure == Never {
        modifier(let: publisher) { $0.onReceive($1, perform: action) }
    }

    /// Adds an action to perform when this view detects data emitted by the given publisher.
    ///
    /// - Parameters:
    ///   - publisher: The publisher to subscribe to.
    ///   - action: The action to perform when an event is emitted by `publisher`.
    /// - Returns: A view that triggers an async action when publisher emits an event.
    func onReceive<P>(
        _ publisher: P?,
        perform action: @escaping () async -> Void
    ) -> some View where P: Publisher, P.Failure == Never {
        // Deprecate in favour of `.task` after converting publishers to `AsyncStream`
        onReceive(publisher) { _ in async { await action() } }
    }

    /// Adds an action to perform when this view detects data emitted by the given `ObservableObject`.
    ///
    /// - Parameters:
    ///   - observableObject: The `ObservableObject` to subscribe to.
    ///   - action: The action to perform when an event is emitted by the `objectWillChange` publisher of the `ObservableObject`.
    /// - Returns: A view that triggers an action when publisher emits an event.
    func onReceive<O>(
        _ observableObject: O,
        perform action: @escaping () -> Void
    ) -> some View where O: ObservableObject {
        onReceive(observableObject.objectWillChange) { _ in
            action()
        }
    }
}

// MARK: - Notification

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
    func onNotification(
        for name: Notification.Name,
        object: AnyObject? = nil,
        perform action: @escaping (Notification) async -> Void
    ) -> some View {
        onReceive(NotificationCenter.default.publisher(for: name, object: object)) { notification in
            async { await action(notification) }
        }
    }

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
        perform action: @escaping () async -> Void
    ) -> some View {
        onReceive(NotificationCenter.default.publisher(for: name, object: object)) { _ in
            async { await action() }
        }
    }
}

// MARK: - UI

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
