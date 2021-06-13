//
//  Text.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-06-08.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension Text {
    /// Creates a text view from another text view for isolating localization entries.
    ///
    ///     extension Text {
    ///         static let notificationTitle = Text(
    ///             "Notifications",
    ///             tableName: "NotificationSettings",
    ///             comment: "The section title for notifications group on the settings screen"
    ///         )
    ///     }
    ///
    ///     // Somewhere else in a view...
    ///     Text(.notificationTitle)
    init(_ text: Text) {
        self = text
    }
}

public extension Text {
    /// Creates a text view that displays an optional string with a fallback to a redactable string if `nil`.
    init(redactable content: String?) {
        self.init(content ?? "Loading...")
    }

    /// Creates a text view that displays an optional localized string key with a fallback to a redactable string if `nil`.
    init(redactable content: LocalizedStringKey?) {
        self.init(content ?? "Loading...")
    }
}
