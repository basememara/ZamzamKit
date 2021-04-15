//
//  OverlayDismissButtonModifier.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-04-15.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

private struct OverlayDismissButtonModifier: ViewModifier {
    @Environment(\.presentationMode) private var presentationMode

    func body(content: Content) -> some View {
        content.modifier(if: presentationMode.wrappedValue.isPresented) { content in
            content
                .overlay(
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Label(LocalizedStringKey("Close"), systemImage: "xmark")
                            .labelStyle(IconOnlyLabelStyle())
                            .foregroundColor(Color(.label))
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(Color(.systemBackground).opacity(0.8))
                            )
                    }
                    .padding([.top, .trailing]),
                    alignment: .topTrailing
                )
        }
    }
}

public extension View {
    /// Adds a button to the top trailing corner of a view that dismisses the view if it is currently presented.
    func overlayDismissButton() -> some View {
        modifier(OverlayDismissButtonModifier())
    }
}
