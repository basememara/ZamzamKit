//
//  ViewError.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2019-12-17.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSUUID
import SwiftUI
import ZamzamCore

/// An error to show the user in an alert, with a title, a message and up to two actions.
public struct ViewError: Error, Equatable, Identifiable {
    /// Identifies the error for an alert. Every error gets its own, so two errors with the same content aren't equal.
    public let id = UUID()
    /// The alert's title.
    public let title: String
    /// The text under the title.
    public let message: String?
    /// The alert's main button. Without one the alert has a single button that dismisses it.
    public let action: Action?
    /// The alert's cancel button, used when `action` is set. Without one the cancel button has the system's title.
    public let secondaryAction: Action?

    /// Creates an error from a title.
    public init(
        title: String,
        message: String? = nil,
        action: Action? = nil,
        secondaryAction: Action? = nil
    ) {
        self.title = title
        self.message = message
        self.action = action
        self.secondaryAction = secondaryAction
    }

    /// Creates an error whose title is another error's localized description.
    public init(
        from error: Error,
        message: String? = nil,
        action: Action? = nil,
        secondaryAction: Action? = nil
    ) {
        self.init(
            title: error.localizedDescription,
            message: message,
            action: action,
            secondaryAction: secondaryAction
        )
    }
}

extension ViewError: LocalizedError {
    /// The title.
    public var errorDescription: String? { title }
}

// MARK: - Types

public extension ViewError {
    /// A button for the alert: its title and what it does.
    struct Action: Equatable, Sendable {
        /// The button's title.
        public let title: String
        /// Called on the main actor when the user taps the button.
        public let completion: @MainActor @Sendable () -> Void

        /// Creates an action.
        public init(_ title: String, completion: @escaping @MainActor @Sendable () -> Void) {
            self.title = title
            self.completion = completion
        }

        /// Compares the titles only, since closures can't be compared.
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.title == rhs.title
        }
    }
}

// MARK: - Conversions

public extension Alert {
    /// Creates an alert from the view error.
    init(from error: ViewError) {
        let titleText = Text(error.title)

        let messageText: Text? = {
            guard let message = error.message else { return nil }
            return Text(message)
        }()

        guard let action = error.action else {
            self.init(title: titleText, message: messageText)
            return
        }

        // Alert buttons take plain closures but are always called on the main thread
        let primaryButton: Alert.Button = .default(
            Text(action.title),
            action: { MainActor.assumeIsolated(action.completion) }
        )

        let secondaryButton: Alert.Button = {
            guard let action = error.secondaryAction else {
                return .cancel()
            }

            return .cancel(
                Text(action.title),
                action: { MainActor.assumeIsolated(action.completion) }
            )
        }()

        self.init(
            title: titleText,
            message: messageText,
            primaryButton: primaryButton,
            secondaryButton: secondaryButton
        )
    }
}

private struct AlertModifier: ViewModifier {
    @Binding var error: ViewError?

    func body(content: Content) -> some View {
        content.alert(item: $error, content: Alert.init)
    }
}

public extension View {
    /// Presents an alert for the error while the binding holds one, and sets it to `nil` when the alert is dismissed.
    func alert(error: Binding<ViewError?>) -> some View {
        modifier(AlertModifier(error: error))
    }
}
