//
//  View.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-01-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension View {
    /// Adds a border to this view with the specified color, width, and radius.
    func border(_ color: Color, width: CGFloat = 1, cornerRadius: CGFloat) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius)

        return self
            .clipShape(shape)
            .overlay(shape.stroke(color, lineWidth: width))
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

public extension View {
    /// Applies a modifier to a view.
    ///
    ///     someView
    ///         .modifier {
    ///             if #available(iOS 18, macOS 15, *) {
    ///                 $0.presentationSizing(.form)
    ///             } else {
    ///                 $0
    ///             }
    ///         }
    ///
    /// - Parameters:
    ///   - transform: The modifier to apply to the view.
    /// - Returns: The modified view.
    func modifier<Content>(@ViewBuilder _ transform: (Self) -> Content) -> Content {
        transform(self)
    }
}

// MARK: - Notification

public extension View {
    /// Adds an action to perform each time the notification is posted while this view is on screen.
    ///
    /// - Parameters:
    ///   - name: The name of the notification.
    ///   - action: The action to perform with the notification.
    /// - Returns: A view that runs the action for each notification.
    func onNotification(for name: Notification.Name, perform action: @escaping @MainActor (Notification) -> Void) -> some View {
        task(id: name) {
            for await notification in NotificationCenter.default.notifications(named: name) {
                action(notification)
            }
        }
    }

    /// Adds an action to perform each time the notification is posted while this view is on screen.
    ///
    /// - Parameters:
    ///   - name: The name of the notification.
    ///   - action: The action to perform.
    /// - Returns: A view that runs the action for each notification.
    func onNotification(for name: Notification.Name, perform action: @escaping @MainActor () async -> Void) -> some View {
        task(id: name) {
            for await _ in NotificationCenter.default.notifications(named: name) {
                await action()
            }
        }
    }
}
