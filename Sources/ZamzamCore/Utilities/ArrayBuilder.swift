//
//  ArrayBuilder.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-02-06.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

/// Passes an array of generic elements using function builder syntax.
///
///     struct MyType {
///         let items: [String]
///
///         init(@ArrayBuilder<String> builder: () -> [String]) {
///             self.items = builder()
///         }
///     }
///
///     let list = MyType {
///         "abc"
///         "def"
///         "xyz"
///     }
///
@_functionBuilder
public struct ArrayBuilder<T> {

    public static func buildBlock(_ elements: T...) -> [T] {
        elements
    }
}
