//
//  Reducer.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2020-05-21.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

/// The set of reducers used to mutate the state.
public protocol Reducer {}

/// A closure that mutates the state with a reducer.
public typealias StateReducer<T: Reducer> = (T) -> Void
