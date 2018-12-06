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
        
        watchSession.addObserver(forApplicationContext: Observer { [weak self] result in
            DispatchQueue.main.async {
                self?.receivedContextLabel.setText(result["value"] as? String ?? "")
            }
        })
        
        watchSession.addObserver(forUserInfo: Observer { [weak self] result in
            DispatchQueue.main.async {
                self?.receivedUserInfoLabel.setText(result["value"] as? String ?? "")
            }
        })
        
        watchSession.addObserver(forMessage: Observer { [weak self] message, replyHandler in
            DispatchQueue.main.async {
                self?.receivedMessageLabel.setText(message["value"] as? String ?? "")
            }
        })
    }
    
    @IBAction func sendContextTapped() {
        let value = ["value": "\(Date())"]
        watchSession.transfer(context: value)
        sentContextLabel.setText(value["value"] ?? "")
    }
    
    @IBAction func sendUserInfoTapped() {
        let value = ["value": "\(Date())"]
        watchSession.transfer(userInfo: value)
        sentUserInfoLabel.setText(value["value"] ?? "")
    }
    
    @IBAction func sendMessageTapped() {
        let value = ["value": "\(Date())"]
        watchSession.transfer(message: value)
        sentMessageLabel.setText(value["value"] ?? "")
    }

    @IBAction func alertTapped() {
        present(
            alert: "Test",
            message: "This is the message.",
            includeCancelAction: true
        )
    }
    
    @IBAction func actionSheetTapped() {
        present(
            actionSheet: "Test",
            message: "This is the message.",
            additionalActions: [
                WKAlertAction(title: "Action 1", handler: {}),
                WKAlertAction(title: "Action 2", handler: {}),
                WKAlertAction(title: "Action 3", style: .destructive, handler: {})
            ],
            includeCancelAction: true
        )
    }
    
    @IBAction func sideBySideAlertTapped() {
        present(
            sideBySideAlert: "Test",
            message: "This is the message.",
            additionalActions: [
                WKAlertAction(title: "Action 1", handler: {}),
                WKAlertAction(title: "Action 2", style: .destructive, handler: {}),
                WKAlertAction(title: "Action 3", handler: {})
            ]
        )
    }
}
