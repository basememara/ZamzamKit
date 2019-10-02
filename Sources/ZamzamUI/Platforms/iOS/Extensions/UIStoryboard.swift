//
//  UIStoryboard.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/26/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIStoryboard {

    /// Creates and returns a storyboard object for the specified storyboard resource file in the main bundle of the current application.
    ///
    /// - Parameter name: The name of the storyboard resource file without the filename extension.
    convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }
    
    /// Instantiate view controller using convention of storyboard identifier matching class name.
    ///
    ///     let storyboard = UIStoryboard("Main")
    ///     let controller: MyViewController = storyboard.instantiateViewController()
    ///
    /// - Returns: Instantiated controller from storyboard, or nil if non existent.
    func instantiateViewController<T: UIViewController>() -> T? {
        return instantiateViewController(withIdentifier: String(describing: T.self)) as? T
    }
}
#endif
