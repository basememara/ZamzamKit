//
//  Debounce.swift
//  https://github.com/soffes/RateLimit
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation

/// A debouncer that will delay work items until time limit for the preceding call is over.
///
///     let limiter = Debouncer(limit: 5)
///     var value = ""
///
///     func sendToServer() {
///         limiter.execute {
///             // Sends to server after no typing for 5 seconds
///             // instead of once per character, so:
///             value == "hello" -> true
///         }
///     }
///
///     value.append("h")
///     sendToServer()
///
///     value.append("e")
///     sendToServer()
///
///     value.append("l")
///     sendToServer()
///
///     value.append("l")
///     sendToServer()
///
///     value.append("o")
///     sendToServer()
public final class Debouncer {
    
    // MARK: - Properties
    
    private let limit: TimeInterval
    private let queue: DispatchQueue
    
    private var workItem: DispatchWorkItem?
    private let syncQueue = DispatchQueue(label: "\(DispatchQueue.labelPrefix).Debouncer", attributes: [])
    
    /// Initialize a new debouncer with given delay limit for work items.
    ///
    /// - Parameters:
    ///   - limit: The number of seconds until the execution block is called.
    ///   - queue: The queue to run the execution block asynchronously.
    public init(limit: TimeInterval, queue: DispatchQueue = .main) {
        self.limit = limit
        self.queue = queue
    }
    
    /// Submits a work item and ensures it is not called until the delay is completed.
    ///
    /// - Parameter block: The work item to be invoked on the debouncer.
    @objc public func execute(block: @escaping () -> Void) {
        syncQueue.async { [weak self] in
            if let workItem = self?.workItem {
                workItem.cancel()
                self?.workItem = nil
            }
            
            guard let queue = self?.queue, let limit = self?.limit else { return }
            
            let workItem = DispatchWorkItem(block: block)
            queue.asyncAfter(deadline: .now() + limit, execute: workItem)
            
            self?.workItem = workItem
        }
    }
    
    /// Cancels all work items to allow future work items to be executed with the specified delayed.
    public func reset() {
        syncQueue.async { [weak self] in
            self?.workItem?.cancel()
            self?.workItem = nil
        }
    }
}
