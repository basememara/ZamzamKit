//
//  EventManager.swift
//  ZamzamKit iOS
//  https://github.com/AlbertMontserrat/AMGCalendarManager
//
//  Created by Basem Emara on 2018-09-06.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import EventKit

/// A protocol that accesses the user’s calendar and reminder events and supports the scheduling of new events.
public protocol EventManagerType {
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
    func createEvents<T>(from elements: Array<T>, configure: @escaping (EKEvent, T) -> Void, completion: ((Result<[EKEvent], ZamzamError>) -> Void)?)
    
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

public extension EventManagerType {
    
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

/// An object that accesses the user’s calendar and reminder events and supports the scheduling of new events.
public struct EventManager: EventManagerType {
    private let store: EKEventStore
    private let calendarIdentifier: String?
    private let queue: DispatchQueue
    private let type: EKEntityType = .event
    
    private var calendar: EKCalendar? {
        guard let calendarIdentifier = calendarIdentifier else {
            switch type {
            case .event: return store.defaultCalendarForNewEvents
            case .reminder: return store.defaultCalendarForNewReminders()
            }
        }
        
        return store.calendar(withIdentifier: calendarIdentifier)
    }
}

public extension EventManager {
    
    /// Initializer of object for accessess the user's calendar and reminder events.
    ///
    /// - Parameters:
    ///   - store: The EKEventStore class is an application’s point of contact for accessing calendar and reminder data.
    ///   - calendarIdentifier: The calendar’s unique identifier.
    ///   - queue: The dispatch queue used for tasks and queries.
    init(store: EKEventStore = EKEventStore(),
         withCalendarIdentifier calendarIdentifier: String? = nil,
         queue: DispatchQueue = DispatchQueue(label: ZamzamConstants.bundleIdentifier, qos: .userInteractive)) {
        self.store = store
        self.calendarIdentifier = calendarIdentifier
        self.queue = queue
    }
}

public extension EventManager {
    
    var isAuthorized: Bool {
        return EKEventStore.authorizationStatus(for: type) == .authorized
    }
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
        switch EKEventStore.authorizationStatus(for: type) {
        case .authorized:
            completion(true)
        case .notDetermined:
            store.requestAccess(to: type) { granted, _ in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .restricted, .denied:
            completion(false)
        }
    }
}

public extension EventManager {
    
    func fetchEvent(withIdentifier identifier: String, completion: @escaping (Result<EKEvent?, ZamzamError>) -> Void) {
        requestAccess { granted in
            guard granted else { return completion(.failure(.unauthorized)) }
            
            self.queue.async {
                let event = self.store.event(withIdentifier: identifier)
                
                DispatchQueue.main.async {
                    completion(.success(event))
                }
            }
        }
    }
    
    func fetchEvents(from startDate: Date, to endDate: Date, completion: @escaping (Result<[EKEvent], ZamzamError>) -> Void) {
        requestAccess { granted in
            guard granted else { return completion(.failure(.unauthorized)) }
            
            self.queue.async {
                guard let calendar = self.calendar else {
                    return completion(.failure(.invalidData))
                }
                
                let events = self.store.events(
                    matching: self.store.predicateForEvents(
                        withStart: startDate,
                        end: endDate,
                        calendars: [calendar]
                    )
                )
                
                DispatchQueue.main.async {
                    completion(.success(events))
                }
            }
        }
    }
}

public extension EventManager {
    
    func createEvent(configure: @escaping (EKEvent) -> Void,
                     completion: ((Result<EKEvent, ZamzamError>) -> Void)?) {
        requestAccess { granted in
            guard granted else { completion?(.failure(.unauthorized)); return }
            
            self.queue.async {
                guard let calendar = self.calendar else {
                    completion?(.failure(.invalidData))
                    return
                }
                
                let event = EKEvent(eventStore: self.store).with {
                    $0.calendar = calendar
                    configure($0)
                }
                
                do {
                    try self.store.save(event, span: .thisEvent, commit: true)
                    
                    DispatchQueue.main.async {
                        completion?(.success(event))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion?(.failure(.other(error)))
                    }
                }
            }
        }
    }
    
    func createEvents<T>(from elements: Array<T>,
                         configure: @escaping (EKEvent, T) -> Void,
                         completion: ((Result<[EKEvent], ZamzamError>) -> Void)?) {
        requestAccess { granted in
            guard granted else { completion?(.failure(.unauthorized)); return }
            
            self.queue.async {
                guard let calendar = self.calendar else {
                    completion?(.failure(.invalidData))
                    return
                }
                
                let events = elements.map { element in
                    EKEvent(eventStore: self.store).with {
                        $0.calendar = calendar
                        configure($0, element)
                    }
                }
                
                do {
                    try events.forEach {
                        try self.store.save($0, span: .thisEvent, commit: false)
                    }
                    
                    try self.store.commit()
                    
                    DispatchQueue.main.async {
                        completion?(.success(events))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion?(.failure(.other(error)))
                    }
                }
            }
        }
    }
}

public extension EventManager {
    
    func updateEvent(withIdentifier identifier: String,
                     span: EKSpan,
                     configure: @escaping (EKEvent) -> Void,
                     completion: ((Result<EKEvent, ZamzamError>) -> Void)?) {
        requestAccess { granted in
            guard granted else { completion?(.failure(.unauthorized)); return }
            
            self.queue.async {
                guard let event = self.store.event(withIdentifier: identifier) else {
                    return DispatchQueue.main.async {
                        completion?(.failure(.nonExistent))
                    }
                }
                
                configure(event)
                
                do {
                    try self.store.save(event, span: span, commit: true)
                    
                    DispatchQueue.main.async {
                        completion?(.success(event))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion?(.failure(.other(error)))
                    }
                }
            }
        }
    }
}

public extension EventManager {
    
    func deleteEvent(withIdentifier identifier: String, span: EKSpan, completion: ((Result<Void, ZamzamError>) -> Void)?) {
        requestAccess { granted in
            guard granted else { completion?(.failure(.unauthorized)); return }
            
            self.queue.async {
                guard let event = self.store.event(withIdentifier: identifier) else {
                    // Deleted before or never existed
                    return DispatchQueue.main.async {
                        completion?(.success(()))
                    }
                }
                
                do {
                    try self.store.remove(event, span: span, commit: true)
                    
                    DispatchQueue.main.async {
                        completion?(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion?(.failure(.other(error)))
                    }
                }
            }
        }
    }
    
    func deleteEvents(withIdentifiers identifiers: [String], span: EKSpan, completion: ((Result<Void, ZamzamError>) -> Void)?) {
        guard !identifiers.isEmpty else { completion?(.success(())); return }
        
        requestAccess { granted in
            guard granted else { completion?(.failure(.unauthorized)); return }
            
            self.queue.async {
                let events = identifiers.compactMap {
                    self.store.event(withIdentifier: $0)
                }
                
                guard !events.isEmpty else {
                    // Deleted before or never existed
                    return DispatchQueue.main.async {
                        completion?(.success(()))
                    }
                }
                
                do {
                    try events.forEach {
                        try self.store.remove($0, span: span, commit: false)
                    }
                    
                    try self.store.commit()
                    
                    DispatchQueue.main.async {
                        completion?(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion?(.failure(.other(error)))
                    }
                }
            }
        }
    }
}
