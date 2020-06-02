//
//  StateRepresentable.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2019-11-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import ZamzamCore

/// The data of the component.
public protocol StateRepresentable: AnyObject, Apply {
    associatedtype ActionType: Action
    
    /// Receives an action to mutate the state.
    func callAsFunction(_ action: ActionType)
}

// MARK: - Observable (Pre-SwiftUI)

public extension StateRepresentable {
    
    /// Observation to state changes and executes the block.
    ///
    /// This will not be needed once fully migrated to SwiftUI. `ObservableObject` is planned.
    ///
    /// - Parameters:
    ///   - observer: The block to be executed when the state changes.
    ///   - cancellable: An opaque object to act as the observer and will manage its auto release.
    func subscribe(_ observer: @escaping (StateChange<Self>) -> Void, in cancellable: inout NotificationCenter.Cancellable?) {
        observer(.initial)
        
        NotificationCenter.default.addObserver(forName: .stateDidChange, queue: .main, in: &cancellable) { notification in
            guard let keyPath = notification.userInfo?[.keyPath] as? PartialKeyPath<Self> else { return }
            
            guard let error = self[keyPath: keyPath] as? ViewError else {
                observer(.updated(keyPath))
                return
            }
            
            observer(.failure(error))
        }
    }
    
    /// Publishes the change when the state has changed. Call this during `didSet` with the key path that triggered the change.
    ///
    /// This will not be needed once fully migrated to SwiftUI. `@Publish` is planned.
    ///
    /// - Parameters:
    ///   - keyPath: The key path that triggered the change.
    func notificationPost(for keyPath: PartialKeyPath<Self>) {
        NotificationCenter.default.post(name: .stateDidChange, userInfo: [.keyPath: keyPath])
    }
}

// MARK: - Observable (Post-SwiftUI)

#if canImport(SwiftUI)
import Combine

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension StateRepresentable where Self: ObservableObject, Self.ObjectWillChangePublisher == ObservableObjectPublisher {
    
    /// Publishes the change when the state has changed. Call this during `willSet`.
    ///
    /// Use `@Publish` when fully migrated to SwiftUI then deprecate this method.
    public func combineSend() {
        objectWillChange.send()
    }
}
#endif

// MARK: - Types

public enum StateChange<T: StateRepresentable>: Equatable {
    case initial
    case updated(PartialKeyPath<T>)
    case failure(ViewError)
}

// MARK: - Helpers

private extension NSNotification.Name {
    static let stateDidChange = Notification.Name("stateDidChange")
}

private extension AnyHashable {
    static let keyPath = "keyPath"
}
