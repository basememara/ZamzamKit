//
//  Refreshable.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2020-06-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

/// Exposes refresh start and stop tasks for a type, such as those containing activity or progress indicators.
public protocol Refreshable {
    func beginRefreshing()
    func endRefreshing()
}
