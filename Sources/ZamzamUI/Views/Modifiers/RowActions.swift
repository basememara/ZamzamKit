//
//  RowActions.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2026-10-31.
//  Copyright © 2026 Zamzam Inc. All rights reserved.
//

import SwiftUI

public extension View {
    /// Adds actions to a row: swipe actions on iOS and watchOS, and on macOS, where a form row can't be swiped,
    /// the row's context menu.
    ///
    ///     Text(place.name)
    ///         .rowActions {
    ///             Button("Refresh", systemImage: "location", action: refresh)
    ///         }
    @ViewBuilder
    func rowActions(edge: HorizontalEdge = .trailing, @ViewBuilder _ actions: () -> some View) -> some View {
        #if os(macOS)
        contextMenu(menuItems: actions)
        #else
        swipeActions(edge: edge, content: actions)
        #endif
    }

    /// Adds actions to both edges of a row; macOS puts them in one context menu, since a second one wouldn't show.
    @ViewBuilder
    func rowActions(@ViewBuilder leading: () -> some View, @ViewBuilder trailing: () -> some View) -> some View {
        #if os(macOS)
        contextMenu {
            leading()
            trailing()
        }
        #else
        swipeActions(edge: .leading, content: leading)
            .swipeActions(content: trailing)
        #endif
    }
}
