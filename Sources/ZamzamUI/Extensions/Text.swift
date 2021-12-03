//
//  Text.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-06-08.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

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
