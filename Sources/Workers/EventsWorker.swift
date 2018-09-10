//
//  EventManager.swift
//  ZamzamKit iOS
//  https://github.com/AlbertMontserrat/AMGCalendarManager
//
//  Created by Basem Emara on 2018-09-06.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import EventKit

/// An object that accesses the user’s calendar and reminder events and supports the scheduling of new events.
public struct EventsWorker: EventsWorkerType {
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

public extension EventsWorker {
    
    /// Initializer of object for accessess the user's calendar and reminder events.
    ///
    /// - Parameters:
    ///   - store: The EKEventStore class is an application’s point of contact for accessing calendar and reminder data.
    ///   - calendarIdentifier: The calendar’s unique identifier.
    ///   - queue: The dispatch queue used for tasks and queries.
    init(store: EKEventStore = EKEventStore(),
         withCalendarIdentifier calendarIdentifier: String? = nil,
         queue: DispatchQueue = DispatchQueue(label: "\(ZamzamConstants.bundleNamespace).EventsWorker", qos: .userInteractive)) {
        self.store = store
        self.calendarIdentifier = calendarIdentifier
        self.queue = queue
    }
}

public extension EventsWorker {
    
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

public extension EventsWorker {
    
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
                    return DispatchQueue.main.async {
                        completion(.failure(.invalidData))
                    }
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

public extension EventsWorker {
    
    func createEvent(configure: @escaping (EKEvent) -> Void,
                     completion: ((Result<EKEvent, ZamzamError>) -> Void)?) {
        requestAccess { granted in
            guard granted else { completion?(.failure(.unauthorized)); return }
            
            self.queue.async {
                guard let calendar = self.calendar else {
                    return DispatchQueue.main.async {
                        completion?(.failure(.invalidData))
                    }
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
    
    func createEvents<T>(from elements: [T],
                         configure: @escaping (EKEvent, T) -> Void,
                         completion: ((Result<[EKEvent], ZamzamError>) -> Void)?) {
        guard !elements.isEmpty else { completion?(.success([])); return }
        
        requestAccess { granted in
            guard granted else { completion?(.failure(.unauthorized)); return }
            
            self.queue.async {
                guard let calendar = self.calendar else {
                    return DispatchQueue.main.async {
                        completion?(.failure(.invalidData))
                    }
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

public extension EventsWorker {
    
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

public extension EventsWorker {
    
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
