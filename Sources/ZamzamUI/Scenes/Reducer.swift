//
//  Reducer.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2020-05-21.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

/// A closure that dispatches the action to mutate the state.
public typealias Reducer<T: Action> = (T) -> Void
