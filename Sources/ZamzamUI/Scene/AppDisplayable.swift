//
//  AppDisplayable.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-02-04.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

/// Super displayer for implementing global extensions.
public protocol AppDisplayable {
    
    /// Display error details.
    ///
    /// - Parameter error: The error details to present.
    func display(error: AppModels.Error)
    
    /// Hides spinners, loaders, and anything else
    func endRefreshing()
}
