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

/// Model container for global view errors.
public struct ViewError: Error, Equatable, Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String?
    public let action: Action?
    public let secondaryAction: Action?

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
    public var errorDescription: String? { title }
}

// MARK: - Types

public extension ViewError {
    struct Action: Equatable {
        public let title: String
        public let completion: () -> Void

        public init(_ title: String, completion: @escaping () -> Void) {
            self.title = title
            self.completion = completion
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.title == rhs.title
        }
    }
}

// MARK: - Conversions

public extension Alert {
    /// Creates an alert from the view error.
    init(from error: ViewError) {
        let titleText: Text = Text(error.title)

        let messageText: Text? = {
            guard let message = error.message else { return nil }
            return Text(message)
        }()

        guard let action = error.action else {
            self.init(title: titleText, message: messageText)
            return
        }

        let primaryButton: Alert.Button = .default(
            Text(action.title),
            action: action.completion
        )

        let secondaryButton: Alert.Button = {
            guard let action = error.secondaryAction else {
                return .cancel()
            }

            return .cancel(
                Text(action.title),
                action: action.completion
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
    func alert(error: Binding<ViewError?>) -> some View {
        modifier(AlertModifier(error: error))
    }
}
