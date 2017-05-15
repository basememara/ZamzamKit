//
//  ConditionalAssign.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/22/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

precedencegroup Comparison {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

infix operator ?= : Comparison

/// Assign value if not nil.
public func ?=<T>(left: inout T, right: T?) {
    // https://github.com/hyperoslo/Sugar
    guard let value = right else { return }
    left = value
}

/// Assign value if not nil.
public func ?=<T>(left: inout T?, right: T?) {
    // https://github.com/hyperoslo/Sugar
    guard let value = right else { return }
    left = value
}
