//
//  EventsWorkerType.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2018-09-07.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import EventKit

/// A protocol that accesses the user’s calendar and reminder events and supports the scheduling of new events.
public protocol EventsWorkerType {
    /// Returns the authorization status for the given entity type.
    var isAuthorized: Bool { get }
    
    /// Prompts the user to grant or deny access to event or reminder data.
    ///
    /// - Parameter completion: The block to call when the request completes.
    func requestAccess(completion: @escaping (Bool) -> Void)
    
    /// Returns the first occurrence of an event with a given identifier.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the event.
    ///   - completion: The block to call when the request completes.
    func fetchEvent(withIdentifier identifier: String, completion: @escaping (Result<EKEvent?, ZamzamError>) -> Void)
    
    /// Returns all events between the given dates.
    ///
    /// - Parameters:
    ///   - startDate: The start date of the range of events fetched.
    ///   - endDate: The end date of the range of events fetched.
    ///   - completion: The block to call when the request completes.
    func fetchEvents(from startDate: Date, to endDate: Date, completion: @escaping (Result<[EKEvent], ZamzamError>) -> Void)
    
    /// Saves an event or recurring events to the event store and committing the change.
    ///
    /// - Parameters:
    ///   - configure: The block to call to configure the event.
    ///   - completion: The block to call when the request completes.
    func createEvent(configure: @escaping (EKEvent) -> Void, completion: ((Result<EKEvent, ZamzamError>) -> Void)?)
    
    /// Saves an event or recurring events to the event store and batching the changes.
    ///
    /// - Parameters:
    ///   - elements: The elements to map to events.
    ///   - configure: The block to call to configure the event.
    ///   - completion: The block to call when the request completes.
    func createEvents<T>(from elements: [T], configure: @escaping (EKEvent, T) -> Void, completion: ((Result<[EKEvent], ZamzamError>) -> Void)?)
    
    /// Modifies an event or recurring events to the event store and committing the change.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the event.
    ///   - span: The span to use to indicate whether the save affects future instances of the event in the case of a recurring event.
    ///   - configure: The block to call to configure the event.
    ///   - completion: The block to call when the request completes.
    func updateEvent(withIdentifier identifier: String, span: EKSpan, configure: @escaping (EKEvent) -> Void, completion: ((Result<EKEvent, ZamzamError>) -> Void)?)
    
    /// Removes an event or recurring events from the event store by committing the change.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the event.
    ///   - span: The span to use to indicate whether the delete affects future instances of the event in the case of a recurring event.
    ///   - completion: The block to call when the request completes.
    func deleteEvent(withIdentifier identifier: String, span: EKSpan, completion: ((Result<Void, ZamzamError>) -> Void)?)
    
    /// Removes events or recurring events from the event store by batching the changes.
    ///
    /// - Parameters:
    ///   - identifiers: The identifiers of the events.
    ///   - span: The span to use to indicate whether the delete affects future instances of the event in the case of a recurring event.
    ///   - completion: The block to call when the request completes.
    func deleteEvents(withIdentifiers identifiers: [String], span: EKSpan, completion: ((Result<Void, ZamzamError>) -> Void)?)
}

// MARK: - Default parameters

public extension EventsWorkerType {
    
    /// Saves an event or recurring events to the event store and committing the change.
    ///
    /// - Parameters:
    ///   - configure: The block to call to configure the event.
    func createEvent(configure: @escaping (EKEvent) -> Void) {
        createEvent(configure: configure, completion: nil)
    }
    
    /// Saves an event or recurring events to the event store and batching the changes.
    ///
    /// - Parameters:
    ///   - elements: The elements to map to events.
    ///   - configure: The block to call to configure the event.
    func createEvents<T>(from elements: Array<T>, configure: @escaping (EKEvent, T) -> Void) {
        createEvents(from: elements, configure: configure, completion: nil)
    }
    
    /// Modifies an event or recurring events to the event store and committing the change.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the event.
    ///   - configure: The block to call to configure the event.
    func updateEvent(withIdentifier identifier: String, configure: @escaping (EKEvent) -> Void) {
        updateEvent(withIdentifier: identifier, configure: configure, completion: nil)
    }
    
    /// Modifies an event or recurring events to the event store and committing the change.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the event.
    ///   - span: The span to use to indicate whether the save affects future instances of the event in the case of a recurring event.
    ///   - configure: The block to call to configure the event.
    func updateEvent(withIdentifier identifier: String, span: EKSpan, configure: @escaping (EKEvent) -> Void) {
        updateEvent(withIdentifier: identifier, span: span, configure: configure, completion: nil)
    }
    
    /// Modifies an event or recurring events to the event store and committing the change.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the event.
    ///   - configure: The block to call to configure the event.
    func updateEvent(withIdentifier identifier: String, configure: @escaping (EKEvent) -> Void, completion: ((Result<EKEvent, ZamzamError>) -> Void)?) {
        updateEvent(withIdentifier: identifier, span: .thisEvent, configure: configure, completion: completion)
    }
    
    /// Removes an event or recurring events from the event store by committing the change.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the event.
    func deleteEvent(withIdentifier identifier: String) {
        deleteEvent(withIdentifier: identifier, completion: nil)
    }
    
    /// Removes an event or recurring events from the event store by committing the change.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the event.
    ///   - span: The span to use to indicate whether the delete affects future instances of the event in the case of a recurring event.
    func deleteEvent(withIdentifier identifier: String, span: EKSpan) {
        deleteEvent(withIdentifier: identifier, span: span, completion: nil)
    }
    
    /// Removes an event or recurring events from the event store by committing the change.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the event.
    ///   - completion: The block to call when the request completes.
    func deleteEvent(withIdentifier identifier: String, completion: ((Result<Void, ZamzamError>) -> Void)?) {
        deleteEvent(withIdentifier: identifier, span: .futureEvents, completion: completion)
    }
    
    /// Removes events or recurring events from the event store by batching the changes.
    ///
    /// - Parameters:
    ///   - identifiers: The identifiers of the events.
    func deleteEvents(withIdentifiers identifiers: [String]) {
        deleteEvents(withIdentifiers: identifiers, completion: nil)
    }
    
    /// Removes events or recurring events from the event store by batching the changes.
    ///
    /// - Parameters:
    ///   - identifiers: The identifiers of the events.
    ///   - span: The span to use to indicate whether the delete affects future instances of the event in the case of a recurring event.
    func deleteEvents(withIdentifiers identifiers: [String], span: EKSpan) {
        deleteEvents(withIdentifiers: identifiers, span: span, completion: nil)
    }
    
    /// Removes events or recurring events from the event store by batching the changes.
    ///
    /// - Parameters:
    ///   - identifiers: The identifiers of the events.
    ///   - completion: The block to call when the request completes.
    func deleteEvents(withIdentifiers identifiers: [String], completion: ((Result<Void, ZamzamError>) -> Void)?) {
        deleteEvents(withIdentifiers: identifiers, span: .futureEvents, completion: completion)
    }
}
