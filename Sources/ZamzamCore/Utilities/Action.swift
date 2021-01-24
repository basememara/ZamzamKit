//
//  Action.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-01-23.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

public struct Action {
    public let title: String
    public let block: () -> Void
    
    public init(_ title: String, block: @escaping () -> Void) {
        self.title = title
        self.block = block
    }
}

extension Action: Equatable {
    
    public static func == (lhs: Action, rhs: Action) -> Bool {
        lhs.title == rhs.title
    }
}
