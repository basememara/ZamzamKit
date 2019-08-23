//
//  WatchController.swift
//  ZamzamKit
//
//  Created by Basem Emara on 6/6/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamCore
import ZamzamKit

class WatchViewController: UIViewController {
    
    @IBOutlet private weak var receivedContextLabel: UILabel!
    @IBOutlet private weak var sentContextLabel: UILabel!
    @IBOutlet private weak var receivedUserInfoLabel: UILabel!
    @IBOutlet private weak var sentUserInfoLabel: UILabel!
    @IBOutlet private weak var receivedMessageLabel: UILabel!
    @IBOutlet private weak var sentMessageLabel: UILabel!
    
    var watchSession: WatchSession {
        return AppDelegate.watchSession
    }
    
    /// Another way to add observer
    var userInfoObserver: WatchSession.ReceiveUserInfoObserver {
        return Observer { [weak self] result in
            DispatchQueue.main.async {
                self?.receivedUserInfoLabel.text = result["value"] as? String ?? ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// One way to add observer
        watchSession.addObserver(forApplicationContext: Observer { [weak self] result in
            DispatchQueue.main.async {
                self?.receivedContextLabel.text = result["value"] as? String ?? ""
            }
        })
        
        watchSession.addObserver(forUserInfo: userInfoObserver)
        watchSession.addObserver(forMessage: messageObserver)
    }
    
    deinit {
        watchSession.removeObservers()
    }
}

private extension WatchViewController {
    
    @IBAction func sendContextTapped() {
        let value = ["value": "\(Date())"]
        watchSession.transfer(context: value)
        sentContextLabel.text = value["value"] ?? ""
    }
    
    @IBAction func sendUserInfoTapped() {
        let value = ["value": "\(Date())"]
        watchSession.transfer(userInfo: value)
        sentUserInfoLabel.text = value["value"] ?? ""
    }
    
    @IBAction func sendMessageTapped() {
        let value = ["value": "\(Date())"]
        watchSession.transfer(message: value)
        sentMessageLabel.text = value["value"] ?? ""
    }
}

extension WatchViewController {
    
    /// Another way to add observer
    var messageObserver: WatchSession.ReceiveMessageObserver {
        return Observer { [weak self] message, _ in
            DispatchQueue.main.async {
                self?.receivedMessageLabel.text = message["value"] as? String ?? ""
            }
        }
    }
}
