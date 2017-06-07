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

    @IBOutlet var receivedContextLabel: WKInterfaceLabel!
    @IBOutlet var sentContextLabel: WKInterfaceLabel!
    @IBOutlet var receivedUserInfoLabel: WKInterfaceLabel!
    @IBOutlet var sentUserInfoLabel: WKInterfaceLabel!
    @IBOutlet var receivedMessageLabel: WKInterfaceLabel!
    @IBOutlet var sentMessageLabel: WKInterfaceLabel!
    
    var watchSession: WatchSession {
        return ExtensionDelegate.watchSession
    }
    
    override func awake(withContext: Any?) {
        super.awake(withContext: withContext)
        
        watchSession.addObserver(forApplicationContext: Observer { [weak self] in
            self?.receivedContextLabel.setText($0["value"] as? String ?? "")
        })
        
        watchSession.addObserver(forUserInfo: Observer { [weak self] in
            self?.receivedUserInfoLabel.setText($0["value"] as? String ?? "")
        })
        
        watchSession.addObserver(forMessage: Observer { [weak self] in
            self?.receivedMessageLabel.setText($0.0["value"] as? String ?? "")
        })
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    @IBAction func sendContextTapped() {
        let value = ["value": "\(Date())"]
        watchSession.transfer(context: value)
        self.sentContextLabel.setText(value["value"] ?? "")
    }
    
    @IBAction func sendUserInfoTapped() {
        let value = ["value": "\(Date())"]
        watchSession.transfer(userInfo: value)
        self.sentUserInfoLabel.setText(value["value"] ?? "")
    }
    
    @IBAction func sendMessageTapped() {
        let value = ["value": "\(Date())"]
        watchSession.transfer(message: value)
        self.sentMessageLabel.setText(value["value"] ?? "")
    }

    @IBAction func alertTapped() {
        present(alert: "Test")
    }
}
