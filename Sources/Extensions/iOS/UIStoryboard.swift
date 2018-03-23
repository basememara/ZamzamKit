//
//  UIStoryboard.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/26/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit

public extension UIStoryboard {

    /**
     Creates and returns a storyboard object for the specified storyboard resource file in the main bundle of the current application.

     - parameter name: The name of the storyboard resource file without the filename extension.

     - returns: A storyboard object for the specified file. If no storyboard resource file matching name exists, an exception is thrown.
     */
    convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }
    
    /**
     Instantiate view controller using convention of storyboard identifier matching class name.

     - returns: Instantiated controller from storyboard, or nil if non existent.
     */
    func instantiateViewController<T: UIViewController>() -> T? {
        return self.instantiateViewController(withIdentifier: String(describing: T.self)) as? T
    }
}
