//
//  ArrayBuilder.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-04-27.
//  More: https://gist.github.com/rjchatfield/72629b22fa915f72bfddd96a96c541eb
//
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

@resultBuilder
public struct ArrayBuilder<T> {
    public static func buildBlock(_ elements: T...) -> [T] {
        elements
    }
}
