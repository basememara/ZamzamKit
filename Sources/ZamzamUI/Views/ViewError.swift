//
//  ViewError.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2019-12-17.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSUUID
import ZamzamCore

/// Model container for global view errors.
public struct ViewError: Error, Equatable, Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String?
    public let action: Action?
    
    public init(
        title: String,
        message: String? = nil,
        action: Action? = nil
    ) {
        self.title = title
        self.message = message
        self.action = action
    }
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

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
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

        self.init(
            title: titleText,
            message: messageText,
            primaryButton: primaryButton,
            secondaryButton: .cancel()
        )
    }
}

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
private struct AlertModifier: ViewModifier {
    @Binding var error: ViewError?

    func body(content: Content) -> some View {
        content.alert(item: $error, content: Alert.init)
    }
}

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public extension View {

    func alert(error: Binding<ViewError?>) -> some View {
        modifier(AlertModifier(error: error))
    }
}
#endif
