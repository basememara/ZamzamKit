//
//  ClearButtonWhileEditingModifier.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-03-14.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

private struct ClearButtonWhileEditingModifier: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {
        content
            .overlay(
                HStack {
                    Spacer()
                    Button(action: { text = "" }) {
                        Label(LocalizedStringKey("Clear"), systemImage: "multiply.circle.fill")
                            .labelStyle(.iconOnly)
                            .foregroundColor(.secondary)
                            .padding(8)
                    }
                }
                .opacity(!text.isEmpty ? 0.8 : 0)
            )
    }
}

public extension View {
    /// The standard clear button is displayed at the trailling side of the text field, when the text field has contents,
    /// as a way for the user to remove text quickly. This button appears automatically based on the value set for this property.
    func clearButtonWhileEditing(_ text: Binding<String>) -> some View {
        modifier(ClearButtonWhileEditingModifier(text: text))
    }
}
