//
//  BlurView.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-01-23.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if os(iOS) && canImport(SwiftUI)
import SwiftUI

/// A view that applies a blurring effect to the content layered behind a visual effect view.
///
/// This is currently a workaround until native SwiftUI support released.
@available(iOS 13, *)
public struct BlurView: UIViewRepresentable {
    private let style: UIBlurEffect.Style
    
    public init(style: UIBlurEffect.Style = .systemUltraThinMaterial) {
        self.style = style
    }
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
#endif
