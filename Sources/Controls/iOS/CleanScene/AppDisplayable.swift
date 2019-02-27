//
//  AppDisplayable.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-02-04.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

public protocol AppDisplayable {
    func display(error: AppModels.Error)
    func endRefreshing()
}

extension AppDisplayable where Self: UIViewController {
    
    public func display(error: AppModels.Error) {
        endRefreshing()
        present(alert: error.title, message: error.message)
    }
}
