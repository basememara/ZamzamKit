//
//  Segueable.swift
//  https://www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/
//
//  Created by Basem Emara on 2/22/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit

public protocol Segueable {
    associatedtype SegueIdentifier: RawRepresentable
    
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?)
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier
}

public extension Segueable where Self: UIViewController, SegueIdentifier.RawValue == String {
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any? = nil) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier)
            else { fatalError("Invalid segue identifier \(String(describing: segue.identifier)).") }
        
        return segueIdentifier
    }
}
