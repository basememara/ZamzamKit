//
//  ConditionalRedacted.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2020-09-20.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension View {
    /// Redacts this view hierarchy as a placeholder while the condition holds.
    ///
    ///     someView
    ///         .redacted(if: model == nil)
    ///
    /// An empty reason when the condition is false leaves any redaction the system applies in place,
    /// such as a widget's privacy redaction on the Lock Screen.
    ///
    /// - Parameter condition: Whether to redact the content.
    /// - Returns: The modified view.
    func redacted(if condition: Bool) -> some View {
        redacted(reason: condition ? .placeholder : [])
    }
}
