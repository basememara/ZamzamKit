//
//  UISwitch.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/30/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit

public extension UISwitch {
	
	/// Toggle the switch.
	///
	/// - Parameter animated: set true to animate the change (default is true)
	func toggle(animated: Bool = true) {
		setOn(!isOn, animated: animated)
	}
}
