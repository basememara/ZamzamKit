//
//  InterfaceController.swift
//  ZamzamKit Example Watch Extension
//
//  Created by Basem Emara on 3/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import WatchKit
import Foundation
import ZamzamKit

class InterfaceController: WKInterfaceController {

    override func awake(withContext: Any?) {
        super.awake(withContext: withContext)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func buttonTapped() {
        present(alert: "Test")
    }
}
