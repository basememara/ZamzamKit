//
//  RoundedCorner.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-03-20.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

struct RoundedRect: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        return Path(path.cgPath)
    }
}
