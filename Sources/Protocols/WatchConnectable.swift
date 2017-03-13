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

public extension WatchConnectable {
    
    /// Determines if the watch is available.
    var isWatchAvailable: Bool {
        guard WCSession.isSupported() else { return false }
        let watchSession = WCSession.default()
        return watchSession.isPaired
            && watchSession.isWatchAppInstalled
            && watchSession.activationState == .activated
    }
    
    /**
     Transfers the values to the watch and overwrite older requests.
     
     - parameter values: The dictionary of values.
     */
    func transferContextToWatch(_ values: [String: Any]) -> Bool {
        guard !values.isEmpty, isWatchAvailable else { return false }
        let watchSession = WCSession.default()
        
        var values = values
        values.removeAllNulls()
        
        do { try watchSession.updateApplicationContext(values) }
        catch { return false }
        
        return true
    }
    
    /**
     Transfers the values to the watch in a queue.
     
     - parameter values: The dictionary of values.
     */
    func transferUserInfoToWatch(_ values: [String: Any]) -> WCSessionUserInfoTransfer? {
        guard !values.isEmpty, isWatchAvailable else { return nil }
        let watchSession = WCSession.default()
        
        var values = values
        values.removeAllNulls()
        
        return watchSession.transferUserInfo(values)
    }
    
    /**
     Transfers the values to the watch in a queue relevant to complications.
     
     - parameter values: The dictionary of values.
     */
    func transferComplicationUserInfoToWatch(_ values: [String: Any]) -> WCSessionUserInfoTransfer? {
        guard !values.isEmpty, isWatchAvailable else { return nil }
        
        let watchSession = WCSession.default()
        guard watchSession.isComplicationEnabled else { return nil }
        
        var values = values
        values.removeAllNulls()
        
        return watchSession.transferCurrentComplicationUserInfo(values)
    }
    
    /// Sends a message immediately to the paired and active device and optionally handles a response.
    ///
    /// - Parameters:
    ///   - values: A dictionary of property list values that you want to send.
    ///   - completion: A reply handler for receiving a response from the counterpart, or the error.
    ///     The dictionary of property list values contains the response from the counterpart.
    func transferMessageToWatch(_ values: [String: Any], completion: @escaping (Result<[String: Any]>) -> Void) {
        guard !values.isEmpty, isWatchAvailable else { return completion(.failure(ZamzamError.notReachable)) }
        
        let watchSession = WCSession.default()
        guard watchSession.isReachable else { return completion(.failure(ZamzamError.general)) }
        
        var values = values
        values.removeAllNulls()
        
        return watchSession.sendMessage(values,
            replyHandler: { completion(.success($0)) },
            errorHandler: { completion(.failure($0)) }
        )
    }
}
