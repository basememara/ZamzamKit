//
//  Deprecated.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-04-27.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSObject

public protocol With: Apply {}
public extension With {
    @available(*, deprecated, renamed: "apply")
    func with(_ block: (Self) -> Void) -> Self { apply(block) }
}
extension NSObject: With {}
