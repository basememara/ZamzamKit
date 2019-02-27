//
//  AppRoutable.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-02-04.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

public protocol AppRoutable: Router {
    var viewController: UIViewController? { get set }
    func dismiss(animated: Bool, completion: (() -> Void)?)
}
