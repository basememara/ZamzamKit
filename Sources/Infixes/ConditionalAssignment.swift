//
//  ConditionalAssign.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/22/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import Foundation

import Foundation

precedencegroup Comparison {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

infix operator ?= : Comparison

/// Assign value if not nil.
/// https://github.com/hyperoslo/Sugar
public func ?=<T>(left: inout T, right: T?) {
    guard let value = right else { return }
    left = value
}

/// Assign value if not nil.
/// https://github.com/hyperoslo/Sugar
public func ?=<T>(left: inout T?, right: T?) {
    guard let value = right else { return }
    left = value
}
