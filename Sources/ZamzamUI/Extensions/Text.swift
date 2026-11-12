//
//  Text.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-06-08.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension Text {
    /// Creates a text view for an optional string. `nil` shows "Loading..." as text to redact while the value loads.
    init(redactable content: String?) {
        self.init(content ?? "Loading...")
    }

    /// Creates a text view for an optional localized key. `nil` shows "Loading..." as text to redact while the value loads.
    init(redactable content: LocalizedStringKey?) {
        self.init(content ?? "Loading...")
    }
}
