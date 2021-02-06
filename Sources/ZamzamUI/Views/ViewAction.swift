//
//  ViewAction.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-02-06.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

public struct ViewAction {
    public let title: String
    public let block: () -> Void

    public init(_ title: String, block: @escaping () -> Void) {
        self.title = title
        self.block = block
    }
}

extension ViewAction: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title
    }
}
