//
//  Routable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 4/26/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit

public protocol Routable {
    associatedtype StoryboardIdentifier: RawRepresentable
    
    func present(storyboard: StoryboardIdentifier, identifier: String?, animated: Bool, configure: ((UIViewController) -> Void)?)
    func push(storyboard: StoryboardIdentifier, identifier: String?, animated: Bool, configure: ((UIViewController) -> Void)?)
}

public extension Routable where Self: UIViewController, StoryboardIdentifier.RawValue == String {
    
    /**
     Present the intial view controller of the specified storyboard.
     Be sure to set the initial view controller in the target storyboard.

     - parameter storyboard: Storyboard name.
     - parameter identifier: View controller name.
     - parameter animated: Animates the presentation of the storyboard.
     - parameter configure: Configure the view controller before it is loaded.
     */
    func present(storyboard: StoryboardIdentifier, identifier: String? = nil, animated: Bool = true, configure: ((UIViewController) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboard.rawValue)
        
        guard let controller = (identifier != nil
            ? storyboard.instantiateViewController(withIdentifier: identifier!)
            : storyboard.instantiateInitialViewController())
            else { return assertionFailure("Invalid controller for storyboard \(String(describing: storyboard)).") }
        
        configure?(controller)
        
        present(controller, animated: animated, completion: nil)
    }
    
    /**
     Pushes the intial view controller of the specified storyboard to the navigation stack.
     Be sure to set the initial view controller in the target storyboard.

     - parameter storyboard: Storyboard name.
     - parameter identifier: View controller name.
     - parameter animated: Animates the presentation of the storyboard.
     - parameter configure: Configure the view controller before it is loaded.
     */
    func push(storyboard: StoryboardIdentifier, identifier: String? = nil, animated: Bool = true, configure: ((UIViewController) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboard.rawValue)
        
        guard let navigationController = navigationController,
            let controller = (identifier != nil
                ? storyboard.instantiateViewController(withIdentifier: identifier!)
                : storyboard.instantiateInitialViewController())
            else { return assertionFailure("Invalid controller for storyboard \(String(describing: storyboard)).") }
        
        configure?(controller)
                
        navigationController.pushViewController(controller, animated: animated)
    }
}
