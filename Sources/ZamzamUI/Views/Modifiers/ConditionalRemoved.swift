//
//  ConditionalRemoved.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2026-11-05.
//  Copyright © 2026 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension View {
    /// Takes this view out of the hierarchy while the condition holds, ending its state and tasks,
    /// where `hidden(_:)` keeps it alive.
    @ViewBuilder
    func removed(if condition: Bool) -> some View {
        if !condition {
            self
        }
    }
}
