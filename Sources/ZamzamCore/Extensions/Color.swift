//
//  Color.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2/20/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

#if os(macOS)
import AppKit.NSColor

public extension NSColor {
    /// The primary color to use for text labels.
    ///
    /// Unified with iOS color name.
    static let label = NSColor.labelColor

    /// The color to use for secondary text labels.
    ///
    /// Unified with iOS color name.
    static let secondaryLabel = NSColor.secondaryLabelColor

    /// The color to use for the window background.
    ///
    /// Unified with iOS color name.
    static let systemBackground = NSColor.windowBackgroundColor

    /// The color to use for content layered on top of secondary backgrounds.
    ///
    /// Unified with iOS color name.
    static let tertiarySystemBackground = NSColor.controlBackgroundColor
}
#endif
