//
//  WatchSession.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/13/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

#if canImport(WatchConnectivity)
import WatchConnectivity

public class WatchSession: NSObject, WCSessionDelegate {

    private var sessionDefault: WCSession? {
        WCSession.isSupported() ? .default : nil
    }
    
    public override init() {
        super.init()
        guard WCSession.isSupported() else { return }
        sessionDefault?.delegate = self
        guard activationState == .notActivated else { return }
        sessionDefault?.activate()
    }
    
    /// Subscription queues for firing within delegates
    private var activationDidCompleteSingle = Synchronized<[ActivationHandler]>([])
    private var didBecomeInactive = Synchronized<[Observer<() -> Void>]>([])
    private var didDeactivate = Synchronized<[Observer<() -> Void>]>([])
    private var stateDidChange = Synchronized<[Observer<() -> Void>]>([])
    private var reachabilityDidChange = Synchronized<[ReachabilityChangeObserver]>([])
    private var didReceiveApplicationContext = Synchronized<[ReceiveApplicationContextObserver]>([])
    private var didReceiveUserInfo = Synchronized<[ReceiveUserInfoObserver]>([])
    private var didReceiveMessage = Synchronized<[ReceiveMessageObserver]>([])
    
    deinit {
        // Empty task queues of references
        activationDidCompleteSingle.value { $0.removeAll() }
        didBecomeInactive.value { $0.removeAll() }
        didDeactivate.value { $0.removeAll() }
        stateDidChange.value { $0.removeAll() }
        reachabilityDidChange.value { $0.removeAll() }
        didReceiveApplicationContext.value { $0.removeAll() }
        didReceiveUserInfo.value { $0.removeAll() }
        didReceiveMessage.value { $0.removeAll() }
    }
}

// MARK: - Location manager observers

public extension WatchSession {

    func addObserver(forInactive observer: Observer<() -> Void>) {
        didBecomeInactive.value { $0.append(observer) }
    }

    func removeObserver(forInactive observer: Observer<() -> Void>) {
        didBecomeInactive.value { $0.remove(observer) }
    }

    func addObserver(forDeactivate observer: Observer<() -> Void>) {
        didDeactivate.value { $0.append(observer) }
    }

    func removeObserver(forDeactivate observer: Observer<() -> Void>) {
        didDeactivate.value { $0.remove(observer) }
    }

    func addObserver(forStateChange observer: Observer<() -> Void>) {
        stateDidChange.value { $0.append(observer) }
    }

    func removeObserver(forStateChange observer: Observer<() -> Void>) {
        stateDidChange.value { $0.remove(observer) }
    }

    func addObserver(_ observer: ReachabilityChangeObserver) {
        reachabilityDidChange.value { $0.append(observer) }
    }

    func removeObserver(_ observer: ReachabilityChangeObserver) {
        reachabilityDidChange.value { $0.remove(observer) }
    }

    func addObserver(forApplicationContext observer: ReceiveApplicationContextObserver) {
        didReceiveApplicationContext.value { $0.append(observer) }
    }

    func removeObserver(forApplicationContext observer: ReceiveApplicationContextObserver) {
        didReceiveApplicationContext.value { $0.remove(observer) }
    }

    func addObserver(forUserInfo observer: ReceiveUserInfoObserver) {
        didReceiveUserInfo.value { $0.append(observer) }
    }

    func removeObserver(forUserInfo observer: ReceiveUserInfoObserver) {
        didReceiveUserInfo.value { $0.remove(observer) }
    }

    func addObserver(forMessage observer: ReceiveMessageObserver) {
        didReceiveMessage.value { $0.append(observer) }
    }

    func removeObserver(forMessage observer: ReceiveMessageObserver) {
        didReceiveMessage.value { $0.remove(observer) }
    }
    
    func removeObservers(with prefix: String) {
        let prefix = prefix + "."
    
        didBecomeInactive.value { $0.removeAll { $0.id.hasPrefix(prefix) } }
        didDeactivate.value { $0.removeAll { $0.id.hasPrefix(prefix) } }
        stateDidChange.value { $0.removeAll { $0.id.hasPrefix(prefix) } }
        reachabilityDidChange.value { $0.removeAll { $0.id.hasPrefix(prefix) } }
        didReceiveApplicationContext.value { $0.removeAll { $0.id.hasPrefix(prefix) } }
        didReceiveUserInfo.value { $0.removeAll { $0.id.hasPrefix(prefix) } }
        didReceiveMessage.value { $0.removeAll { $0.id.hasPrefix(prefix) } }
    }

    func removeObservers(from file: String = #file) {
        removeObservers(with: file)
    }
}

// MARK: - Nested types

public extension WatchSession {

    /// Handler queue types
    typealias ActivationHandler = (Bool) -> Void
    typealias ReachabilityChangeObserver = Observer<(Bool) -> Void>
    typealias ReceiveApplicationContextObserver = Observer<([String: Any]) -> Void>
    typealias ReceiveUserInfoObserver = Observer<([String: Any]) -> Void>
    typealias ReceiveMessageObserver = Observer<([String: Any], ([String: Any]) -> Void) -> Void>
}

public extension WatchSession {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        let handlers = activationDidCompleteSingle.value
        activationDidCompleteSingle.value { $0.removeAll() }
        
        handlers.forEach { task in
            DispatchQueue.main.async {
                task(activationState == .activated)
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        let handlers = didBecomeInactive.value
        handlers.forEach { task in
            DispatchQueue.main.async {
                task.handler()
            }
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        let handlers = didDeactivate.value
        handlers.forEach { task in
            DispatchQueue.main.async {
                task.handler()
            }
        }
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        let handlers = stateDidChange.value
        handlers.forEach { task in
            DispatchQueue.main.async {
                task.handler()
            }
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        let handlers = reachabilityDidChange.value
        handlers.forEach { task in
            DispatchQueue.main.async {
                task.handler(session.isReachable)
            }
        }
    }
}

public extension WatchSession {
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        let handlers = didReceiveApplicationContext.value
        handlers.forEach { task in
            DispatchQueue.main.async {
                task.handler(applicationContext)
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        let handlers = didReceiveUserInfo.value
        handlers.forEach { task in
            DispatchQueue.main.async {
                task.handler(userInfo)
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        let handlers = didReceiveMessage.value
        handlers.forEach { task in
            DispatchQueue.main.async {
                task.handler(message, replyHandler)
            }
        }
    }
}

public extension WatchSession {
    
    /// Determines if the watch is available.
    var isAvailable: Bool {
        guard let session = sessionDefault else { return false }
        
        #if os(iOS)
        return session.activationState == .activated
            && session.isPaired
            && session.isWatchAppInstalled
        #else
        return session.activationState == .activated
        #endif
    }
    
    /// The current activation state of the session.
    var activationState: WCSessionActivationState {
        sessionDefault?.activationState ?? .notActivated
    }
    
    /// The most recent contextual data sent to the paired and active device.
    var applicationContext: [String: Any] {
        sessionDefault?.applicationContext ?? [:]
    }
    
    /// Request the one-time delivery of the user’s current location.
    ///
    /// - Parameter completion: The completion with the location object.
    func activate(completion: ActivationHandler? = nil) {
        guard let session = sessionDefault else {
            completion?(false)
            return
        }
        
        guard session.activationState == .notActivated else {
            completion?(session.activationState == .activated)
            return
        }
        
        if let completion = completion {
            activationDidCompleteSingle.value { $0.append(completion) }
        }
        
        session.activate()
    }
}

public extension WatchSession {
    
    /// Transfers the values to the watch and overwrite older requests.
    ///
    /// - Parameters:
    ///   - values: The dictionary of values.
    ///   - completion: The callback of the success of the transmission.
    func transfer(context values: [String: Any], completion: ((Result<Bool, ZamzamError>) -> Void)? = nil) {
        guard !values.isEmpty else {
            completion?(.success(true))
            return
        }
    
        activate {
            guard $0, let session = self.sessionDefault, self.isAvailable else {
                completion?(.failure(.notReachable))
                return
            }
            
            let values = values.compactMapValues { $0 is NSNull ? nil : $0 }
            
            do {
                try session.updateApplicationContext(values)
            } catch {
                completion?(.failure(.other(error)))
                return
            }
            
            completion?(.success(true))
        }
    }
    
    /// Transfers the values to the watch in a queue.
    ///
    /// - Parameters:
    ///   - values: The dictionary of values.
    ///   - completion: The callback of the success with the transmission object.
    func transfer(userInfo values: [String: Any], completion: ((Result<WCSessionUserInfoTransfer?, ZamzamError>) -> Void)? = nil) {
        guard !values.isEmpty else { completion?(.success(nil)); return }
    
        activate {
            guard $0, let session = self.sessionDefault, self.isAvailable else {
                completion?(.failure(.notReachable))
                return
            }
            
            let values = values.compactMapValues { $0 is NSNull ? nil : $0 }
            let transfer = session.transferUserInfo(values)
            
            completion?(.success(transfer))
        }
    }
    
    /// Sends a message immediately to the paired and active device and optionally handles a response.
    ///
    /// - Parameters:
    ///   - values: A dictionary of property list values that you want to send.
    ///   - completion: A reply handler for receiving a response from the counterpart, or the error.
    ///     The dictionary of property list values contains the response from the counterpart.
    func transfer(message values: [String: Any], completion: ((Result<[String: Any], ZamzamError>) -> Void)? = nil) {
        guard !values.isEmpty else {
            completion?(.success([:]))
            return
        }
    
        activate {
            guard $0, let session = self.sessionDefault, self.isAvailable else {
                completion?(.failure(.notReachable))
                return
            }
            
            guard session.isReachable else {
                completion?(.failure(.general))
                return
            }
            
            let values = values.compactMapValues { $0 is NSNull ? nil : $0 }
            
            return session.sendMessage(values,
                replyHandler: { response in
                    DispatchQueue.main.async {
                        completion?(.success(response))
                    }
                },
                errorHandler: { error in
                    DispatchQueue.main.async {
                        completion?(.failure(.other(error)))
                    }
                }
            )
        }
    }
}

#if os(iOS)
public extension WatchSession {

    /// The number of remaining times you can send complication data from the iOS app to the WatchKit extension
    var remainingComplicationTransfers: Int {
        sessionDefault?.remainingComplicationUserInfoTransfers ?? 0
    }

    /// A Boolean value indicating whether the Watch app’s complication is in use on the currently paired and active Apple Watch.
    var isComplicationEnabled: Bool {
        sessionDefault?.isComplicationEnabled ?? false
    }
    
    /// A directory for storing information specific to the currently paired and active Apple Watch.
    var directoryURL: URL? {
        sessionDefault?.watchDirectoryURL
    }
    
    /// Transfers the values to the watch in a queue relevant to complications.
    ///
    /// - Parameters:
    ///   - values: The dictionary of values.
    ///   - completion: The callback of the success with the transmission object.
    func transfer(complication values: [String: Any], completion: ((Result<WCSessionUserInfoTransfer?, ZamzamError>) -> Void)? = nil) {
        guard !values.isEmpty else { completion?(.success(nil)); return }
    
        activate {
            guard $0, let session = self.sessionDefault, self.isAvailable else {
                completion?(.failure(.notReachable))
                return
            }
            
            guard session.isComplicationEnabled else {
                completion?(.failure(.general))
                return
            }
            
            let values = values.compactMapValues { $0 is NSNull ? nil : $0 }
            let transfer = session.transferCurrentComplicationUserInfo(values)
            completion?(.success(transfer))
        }
    }
}
#endif
#endif
