//
//  WatchConnectable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/18/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import WatchConnectivity

public protocol WatchConnectable {
    
}

@available(iOS 9, *)
public extension WatchConnectable {
    
    var isWatchAvailable: Bool {
        let watchSession = WCSession.default()
        var activationState = true
        
        if #available(iOS 9.3, *) {
            activationState = watchSession.activationState == .activated
        }
        
        return watchSession.isPaired && watchSession.isWatchAppInstalled && activationState
    }
    
    /**
     Transfers the values to the watch and overwrite older requests.
     
     - parameter values: The dictionary of values.
     */
    func transferContextToWatch(_ values: [String: Any]) {
        let watchSession = WCSession.default()
        if isWatchAvailable {
            var values = values
            do {
                _ = values.removeAllNulls()
                try watchSession.updateApplicationContext(values)
            } catch {
                // TODO: Log error
            }
        }
    }
    
    /**
     Transfers the values to the watch in a queue.
     
     - parameter values: The dictionary of values.
     */
    func transferUserInfoToWatch(_ values: [String: Any]) {
        let watchSession = WCSession.default()
        if isWatchAvailable {
            var values = values
            _ = values.removeAllNulls()
            watchSession.transferUserInfo(values)
        }
    }
    
    /**
     Transfers the values to the watch in a queue relevant to complications.
     
     - parameter values: The dictionary of values.
     */
    func transferComplicationUserInfoToWatch(_ values: [String: Any]) {
        let watchSession = WCSession.default()
        
        if isWatchAvailable {
            var values = values
            _ = values.removeAllNulls()
            watchSession.transferCurrentComplicationUserInfo(values)
        }
    }
}
